import { atom } from 'nanostores'

export const $activeModal = atom<string>('')

export const openModal = (modalName: string): void => {
  modalName && $activeModal.set(modalName)
}

export const closeModal = (modalName?: string): void => {
  if (modalName) {
    if ($activeModal.get() === modalName) {
      $activeModal.set('')
    }
  } else {
    $activeModal.set('')
  }
}
