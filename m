Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34277 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753744Ab1B1XZk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Feb 2011 18:25:40 -0500
Received: by iyb26 with SMTP id 26so3371949iyb.19
        for <linux-wireless@vger.kernel.org>; Mon, 28 Feb 2011 15:25:40 -0800 (PST)
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 28 Feb 2011 15:25:20 -0800
Message-ID: <AANLkTi=ua+OpGC34E73smOsyF4Mt8HTesgEn_jDmdNZ8@mail.gmail.com>
Subject: ath6kl: cleanup Two series pending in queue and one regression found
To: devel@driverdev.osuosl.org, Naveen Singh <nsingh@atheros.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just FYI - here is my pending cleanup work on ath6kl, these will be
split up into two series. Naveen is testing the first series right now
but ran into a *regression* on ath6kl so ... that regression will be
bisected next by Naveen and once that is all ironed out we will have
to send the fix and then my first series...

http://www.kernel.org/pub/linux/kernel/people/mcgrof/patches/ath6kl/2011/02/28/all-2011-02-28-not-tested-v1.patch

Javier Martinez Canillas (1):
      staging: ath6kl: Cast variable to size_t to avoid compile warning

Luis R. Rodriguez (57):
      ath6kl: s|A_MEMCPY|memcpy|g
      ath6kl: s|A_MEMCMP|memcmp|g
      ath6kl: remove-typedef: A_UCHAR
      ath6kl: remove-typedef AGGR_INFO
      ath6kl: remove-typedef AR3K_CONFIG_INFO
      ath6kl: remove-typedef AR6000_USER_SETKEYS_INFO
      ath6kl: remove-typedef AR6K_ASYNC_REG_IO_BUFFER
      ath6kl: remove-typedef AR6K_DEVICE
      ath6kl: remove-typedef AR6K_GMBOX_CTRL_REGISTERS
      ath6kl: remove-typedef AR6K_GMBOX_INFO
      ath6kl: remove-typedef AR6K_HCI_BRIDGE_INFO
      ath6kl: remove-typedef AR6K_IRQ_ENABLE_REGISTERS
      ath6kl: remove-typedef AR6K_IRQ_PROC_REGISTERS
      ath6kl: remove-typedef AR_VIRTUAL_INTERFACE_T
      ath6kl: remove-typedef ATHBT_FILTER_INSTANCE
      ath6kl: remove-typedef ATH_DEBUG_MASK_DESCRIPTION
      ath6kl: remove-typedef BUFFER_PROC_LIST
      ath6kl: remove-typedef COMMON_CREDIT_STATE_INFO
      ath6kl: remove-typedef DEV_SCATTER_DMA_VIRTUAL_INFO
      ath6kl: remove-tyepdef DL_LIST and PDL_LIST pointer
      ath6kl: remove-typedef GMBOX_PROTO_HCI_UART
      ath6kl: remove-typedef HCI_TRANSPORT_CALLBACKS
      ath6kl: remove-typedef HCI_TRANSPORT_CONFIG_INFO
      ath6kl: remove-typedef HCI_TRANSPORT_MISC_HANDLES
      ath6kl: remove-typedef HCI_TRANSPORT_PROPERTIES
      ath6kl: remove-typedef HIF_DEVICE_IRQ_YIELD_PARAMS
      ath6kl: remove-typedef HIF_DEVICE_MBOX_INFO
      ath6kl: remove-typedef HIF_DEVICE_OS_DEVICE_INFO
      ath6kl: remove-typedef HIF_DEVICE_SCATTER_SUPPORT_INFO
      ath6kl: remove-typedef HIF_MBOX_PROPERTIES
      ath6kl: remove-typedef HIF_PENDING_EVENTS_INFO
      ath6kl: remove-typedef HIF_SCATTER_ITEM
      ath6kl: remove-typedef HIF_SCATTER_REQ_PRIV
      ath6kl: remove-typedef HIF_SCATTER_REQ
      ath6kl: remove-typedef HTC_CONTROL_BUFFER
      ath6kl: remove-typedef HTC_ENDPOINT
      ath6kl: remove-typedef HTC_ENDPOINT_CREDIT_DIST
      ath6kl: remove-typedef HTC_ENDPOINT_STATS
      ath6kl: remove-typedef HTC_EP_CALLBACKS
      ath6kl: remove-typedef HTC_FRAME_HDR
      ath6kl: remove-typedef HTC_INIT_INFO
      ath6kl: remove-typedef HTC_PACKET
      ath6kl: remove-typedef HTC_PACKET_QUEUE
      ath6kl: remove-typedef HTC_RX_PACKET_INFO
      ath6kl: remove-typedef HTC_SERVICE_CONNECT_REQ
      ath6kl: remove-typedef HTC_SERVICE_CONNECT_RESP
      ath6kl: remove-typedef HTC_TARGET
      ath6kl: remove-typedef HTC_TX_PACKET_INFO
      ath6kl: remove-typedef OSBUF_HOLD_Q
      ath6kl: remove-typedef PSCmdPacket
      ath6kl: remove-typedef RXTID
      ath6kl: remove-typedef RXTID_STATS
      ath6kl: remove-typedef ST_PS_DATA_FORMAT
      ath6kl: remove-typedef ST_READ_STATUS
      ath6kl: remove-typedef WINDOW_SNAPSHOT
      ath6kl: remove-typedef AR_SOFTC_T
      ath6kl: remove-typedef HIF_DEVICE

  Luis
