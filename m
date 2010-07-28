Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:37985 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab0G1Rxk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jul 2010 13:53:40 -0400
Received: by ewy23 with SMTP id 23so1887352ewy.19
        for <linux-wireless@vger.kernel.org>; Wed, 28 Jul 2010 10:53:37 -0700 (PDT)
From: Alexey Shvetsov <alexxy@gentoo.org>
Reply-To: alexxy@gentoo.org
To: "Inaky Perez-Gonzalez" <inaky.perez-gonzalez@intel.com>,
	wimax@linuxwimax.org, linux-wireless@vger.kernel.org
Subject: Re: [BUG] after starting wimaxd at boot iwlagn module will crash for intel 6250 card
Date: Wed, 28 Jul 2010 21:53:46 +0400
References: <201007280028.48674.alexxy@gentoo.org> <1280270313.26204.288.camel@localhost.localdomain>
In-Reply-To: <1280270313.26204.288.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2316676.jduGYeo2zY";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <201007282154.06383.alexxy@gentoo.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2316676.jduGYeo2zY
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Updated relevant part of logs for this bug

Jul 27 15:19:16 x201 wimaxd:
daemon starts
Jul 27 15:19:16 x201 wimaxd: pdifile is created
Jul 27
15:19:16 x201 wimaxd: wimaxd event: AppSrv is ready
Jul 27 15:19:27 x201
kernel: iwlagn 0000:02:00.0: Microcode SW error detected.  Restarting
0x2000000.
Jul 27 15:19:27 x201 kernel: iwlagn 0000:02:00.0: Loaded firmware
version: 9.201.4.1 build 24255
Jul 27 15:19:27 x201 kernel: iwlagn
0000:02:00.0: Start IWL Error Log Dump:
Jul 27 15:19:27 x201 kernel: iwlagn
0000:02:00.0: Status: 0x000312E4, count: 5
Jul 27 15:19:27 x201 kernel:
iwlagn 0000:02:00.0: Desc                               Time       data1   =
=20
 data2      line
Jul 27 15:19:27 x201 kernel: iwlagn 0000:02:00.0: SYSASSERT
                   (#05) 0000003432 0x000000BE 0x8000000D 453
Jul 27
15:19:27 x201 kernel: iwlagn 0000:02:00.0: pc      blink1  blink2  ilink1=20
ilink2  hcmd
Jul 27 15:19:27 x201 kernel: iwlagn 0000:02:00.0: 0x1C548
0x1E674 0x1E674 0x009D6 0x00000 0x4360095
Jul 27 15:19:27 x201 kernel:
iwlagn 0000:02:00.0: CSR values:
Jul 27 15:19:27 x201 kernel: iwlagn
0000:02:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
Jul
27 15:19:27 x201 kernel: iwlagn 0000:02:00.0:        CSR_HW_IF_CONFIG_REG:
0X00480303
Jul 27 15:19:27 x201 kernel: iwlagn 0000:02:00.0:        =20
CSR_INT_COALESCING: 0X00000040
Jul 27 15:19:27 x201 kernel: iwlagn
0000:02:00.0:                     CSR_INT: 0X00000000
Jul 27 15:19:27 x201
kernel: iwlagn 0000:02:00.0:                CSR_INT_MASK: 0X00000000
Jul 27
15:19:27 x201 kernel: iwlagn 0000:02:00.0:           CSR_FH_INT_STATUS:
0X00000000
Jul 27 15:19:27 x201 kernel: iwlagn 0000:02:00.0:               =20
CSR_GPIO_IN: 0X0000000f
Jul 27 15:19:27 x201 kernel: iwlagn 0000:02:00.0:  =20
               CSR_RESET: 0X00000000
Jul 27 15:19:27 x201 kernel: iwlagn
0000:02:00.0:                CSR_GP_CNTRL: 0X080403c5
Jul 27 15:19:27 x201
kernel: iwlagn 0000:02:00.0:                  CSR_HW_REV: 0X00000084
Jul 27
15:19:27 x201 kernel: iwlagn 0000:02:00.0:              CSR_EEPROM_REG:
0Xa0820ffd
Jul 27 15:19:27 x201 kernel: iwlagn 0000:02:00.0:             =20
CSR_EEPROM_GP: 0X90000801
Jul 27 15:19:27 x201 kernel: iwlagn 0000:02:00.0:=20
            CSR_OTP_GP_REG: 0X00030001
Jul 27 15:19:27 x201 kernel: iwlagn
0000:02:00.0:                 CSR_GIO_REG: 0X00080042
Jul 27 15:19:27 x201
kernel: iwlagn 0000:02:00.0:            CSR_GP_UCODE_REG: 0X0000056a
Jul 27
15:19:27 x201 kernel: iwlagn 0000:02:00.0:           CSR_GP_DRIVER_REG:
0X00000004
Jul 27 15:19:27 x201 kernel: iwlagn 0000:02:00.0:         =20
CSR_UCODE_DRV_GP1: 0X00000001
Jul 27 15:19:27 x201 kernel: iwlagn
0000:02:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
Jul 27 15:19:27 x201
kernel: iwlagn 0000:02:00.0:                 CSR_LED_REG: 0X00000058
Jul 27
15:19:27 x201 kernel: iwlagn 0000:02:00.0:        CSR_DRAM_INT_TBL_REG:
0X880ffffe
Jul 27 15:19:27 x201 kernel: iwlagn 0000:02:00.0:      =20
CSR_GIO_CHICKEN_BITS: 0X27800200
Jul 27 15:19:27 x201 kernel: iwlagn
0000:02:00.0:             CSR_ANA_PLL_CFG: 0X00000000
Jul 27 15:19:27 x201
kernel: iwlagn 0000:02:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
Jul 27
15:19:27 x201 kernel: iwlagn 0000:02:00.0:        CSR_DBG_HPET_MEM_REG:
0Xffff0000
Jul 27 15:19:27 x201 kernel: iwlagn 0000:02:00.0: FH register
values:
Jul 27 15:19:27 x201 kernel: iwlagn 0000:02:00.0:       =20
=46H_RSCSR_CHNL0_STTS_WPTR_REG: 0X0ffede00
Jul 27 15:19:27 x201 kernel: iwlagn
0000:02:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X00ffedf0
Jul 27
15:19:27 x201 kernel: iwlagn 0000:02:00.0:                =20
=46H_RSCSR_CHNL0_WPTR: 0X00000090
Jul 27 15:19:27 x201 kernel: iwlagn
0000:02:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80819104
Jul 27
15:19:27 x201 kernel: iwlagn 0000:02:00.0:        =20
=46H_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
Jul 27 15:19:27 x201 kernel: iwlagn
0000:02:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
Jul 27
15:19:27 x201 kernel: iwlagn 0000:02:00.0:  =20
=46H_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
Jul 27 15:19:27 x201 kernel:
iwlagn 0000:02:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
Jul 27
15:19:27 x201 kernel: iwlagn 0000:02:00.0:               =20
=46H_TSSR_TX_ERROR_REG: 0X00000000
Jul 27 15:19:27 x201 kernel: iwlagn
0000:02:00.0: Start IWL Event Log Dump: display last 20 entries
Jul 27
15:19:27 x201 kernel: iwlagn 0000:02:00.0:
EVT_LOGT:0001676513:0x00000196:0601
Jul 27 15:19:27 x201 kernel: iwlagn
0000:02:00.0: EVT_LOGT:0001676513:0xffffffff:0600
Jul 27 15:19:27 x201
kernel: iwlagn 0000:02:00.0: EVT_LOGT:0001676514:0x00000004:0600
Jul 27
15:19:27 x201 kernel: iwlagn 0000:02:00.0:
EVT_LOGT:0001676514:0x0000019a:0606
Jul 27 15:19:27 x201 kernel: iwlagn
0000:02:00.0: EVT_LOGT:0001676515:0x000001f1:0615
Jul 27 15:19:27 x201
kernel: iwlagn 0000:02:00.0: EVT_LOGT:0001676567:0x000182f7:0615
Jul 27
15:19:27 x201 kernel: iwlagn 0000:02:00.0:
EVT_LOGT:0001676568:0x00288000:0615
Jul 27 15:19:27 x201 kernel: iwlagn
0000:02:00.0: EVT_LOGT:0001676568:0xffffffff:0615
Jul 27 15:19:27 x201
kernel: iwlagn 0000:02:00.0: EVT_LOGT:0001676569:0x00000054:0601
Jul 27
15:19:27 x201 kernel: iwlagn 0000:02:00.0:
EVT_LOGT:0001676570:0xffffffff:0615
Jul 27 15:19:27 x201 kernel: iwlagn
0000:02:00.0: EVT_LOGT:0001676576:0x0000006b:0601
Jul 27 15:19:27 x201
kernel: iwlagn 0000:02:00.0: EVT_LOGT:0001676591:0x000000e5:0628
Jul 27
15:19:27 x201 kernel: iwlagn 0000:02:00.0:
EVT_LOGT:0001676591:0x00000000:0628
Jul 27 15:19:27 x201 kernel: iwlagn
0000:02:00.0: EVT_LOGT:0001676591:0x02288000:0628
Jul 27 15:19:27 x201
kernel: iwlagn 0000:02:00.0: EVT_LOGT:0001676591:0x02000000:0628
Jul 27
15:19:27 x201 kernel: iwlagn 0000:02:00.0:
EVT_LOGT:0001676591:0x00000000:0628
Jul 27 15:19:27 x201 kernel: iwlagn
0000:02:00.0: EVT_LOGT:0001676591:0x00000800:0628
Jul 27 15:19:27 x201
kernel: iwlagn 0000:02:00.0: EVT_LOGT:0001676591:0x04000000:0628
Jul 27
15:19:27 x201 kernel: iwlagn 0000:02:00.0:
EVT_LOGT:0001676594:0x0000025d:0601
Jul 27 15:19:27 x201 kernel: iwlagn
0000:02:00.0: EVT_LOGT:0001676684:0x00000000:0125
Jul 27 15:19:27 x201
kernel: iwlagn 0000:02:00.0: Command POWER_TABLE_CMD failed: FW Error
Jul 27
15:19:27 x201 kernel: iwlagn 0000:02:00.0: set power fail, ret =3D -5
Jul 27
15:19:27 x201 kernel: iwlagn 0000:02:00.0: Microcode SW error detected.=20
Restarting 0x2000000.
Jul 27 15:19:27 x201 kernel: iwlagn 0000:02:00.0:
Loaded firmware version: 9.201.4.1 build 24255
Jul 27 15:19:27 x201 kernel:
iwlagn 0000:02:00.0: Start IWL Error Log Dump:
Jul 27 15:19:27 x201 kernel:
iwlagn 0000:02:00.0: Status: 0x00020224, count: 5
Jul 27 15:19:27 x201
kernel: iwlagn 0000:02:00.0: Desc                               Time     =20
data1      data2      line
Jul 27 15:19:27 x201 kernel: iwlagn 0000:02:00.0:
SYSASSERT                    (#05) 0000013122 0x0000008D 0x8000000D 453
Jul
27 15:19:27 x201 kernel: iwlagn 0000:02:00.0: pc      blink1  blink2  ilink1
 ilink2  hcmd
Jul 27 15:19:27 x201 kernel: iwlagn 0000:02:00.0: 0x1EAB8
0x1EAA6 0x1EAA6 0x009D6 0x00000 0x400005A
Jul 27 15:19:27 x201 kernel:
iwlagn 0000:02:00.0: CSR values:
Jul 27 15:19:27 x201 kernel: iwlagn
0000:02:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
Jul
27 15:19:27 x201 kernel: iwlagn 0000:02:00.0:        CSR_HW_IF_CONFIG_REG:
0X00480303
Jul 27 15:19:27 x201 kernel: iwlagn 0000:02:00.0:        =20
CSR_INT_COALESCING: 0X0000ff40
Jul 27 15:19:27 x201 kernel: iwlagn
0000:02:00.0:                     CSR_INT: 0X00000000
Jul 27 15:19:27 x201
kernel: iwlagn 0000:02:00.0:                CSR_INT_MASK: 0X00000000
Jul 27
15:19:27 x201 kernel: iwlagn 0000:02:00.0:           CSR_FH_INT_STATUS:
0X00000000
Jul 27 15:19:27 x201 kernel: iwlagn 0000:02:00.0:               =20
CSR_GPIO_IN: 0X0000000f
Jul 27 15:19:27 x201 kernel: iwlagn 0000:02:00.0:  =20
               CSR_RESET: 0X00000000
Jul 27 15:19:27 x201 kernel: iwlagn
0000:02:00.0:                CSR_GP_CNTRL: 0X080403c5
Jul 27 15:19:27 x201
kernel: iwlagn 0000:02:00.0:                  CSR_HW_REV: 0X00000084
Jul 27
15:19:27 x201 kernel: iwlagn 0000:02:00.0:              CSR_EEPROM_REG:
0Xa0820ffd
Jul 27 15:19:27 x201 kernel: iwlagn 0000:02:00.0:             =20
CSR_EEPROM_GP: 0X90000801
Jul 27 15:19:27 x201 kernel: iwlagn 0000:02:00.0:=20
            CSR_OTP_GP_REG: 0X00030001
Jul 27 15:19:27 x201 kernel: iwlagn
0000:02:00.0:                 CSR_GIO_REG: 0X00080046
Jul 27 15:19:27 x201
kernel: iwlagn 0000:02:00.0:            CSR_GP_UCODE_REG: 0X00000002
Jul 27
15:19:27 x201 kernel: iwlagn 0000:02:00.0:           CSR_GP_DRIVER_REG:
0X00000004
Jul 27 15:19:27 x201 kernel: iwlagn 0000:02:00.0:         =20
CSR_UCODE_DRV_GP1: 0X00000000
Jul 27 15:19:27 x201 kernel: iwlagn
0000:02:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
Jul 27 15:19:27 x201
kernel: iwlagn 0000:02:00.0:                 CSR_LED_REG: 0X00000018
Jul 27
15:19:27 x201 kernel: iwlagn 0000:02:00.0:        CSR_DRAM_INT_TBL_REG:
0X880ffffe
Jul 27 15:19:27 x201 kernel: iwlagn 0000:02:00.0:      =20
CSR_GIO_CHICKEN_BITS: 0X27800200
Jul 27 15:19:27 x201 kernel: iwlagn
0000:02:00.0:             CSR_ANA_PLL_CFG: 0X00000000
Jul 27 15:19:27 x201
kernel: iwlagn 0000:02:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
Jul 27
15:19:27 x201 kernel: iwlagn 0000:02:00.0:        CSR_DBG_HPET_MEM_REG:
0Xffff0000
Jul 27 15:19:27 x201 kernel: iwlagn 0000:02:00.0: FH register
values:
Jul 27 15:19:27 x201 kernel: iwlagn 0000:02:00.0:       =20
=46H_RSCSR_CHNL0_STTS_WPTR_REG: 0X0ffede00
Jul 27 15:19:27 x201 kernel: iwlagn
0000:02:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X00ffedf0
Jul 27
15:19:27 x201 kernel: iwlagn 0000:02:00.0:                =20
=46H_RSCSR_CHNL0_WPTR: 0X00000000
Jul 27 15:19:27 x201 kernel: iwlagn
0000:02:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80819104
Jul 27
15:19:27 x201 kernel: iwlagn 0000:02:00.0:        =20
=46H_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
Jul 27 15:19:27 x201 kernel: iwlagn
0000:02:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
Jul 27
15:19:27 x201 kernel: iwlagn 0000:02:00.0:  =20
=46H_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
Jul 27 15:19:27 x201 kernel:
iwlagn 0000:02:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
Jul 27
15:19:27 x201 kernel: iwlagn 0000:02:00.0:               =20
=46H_TSSR_TX_ERROR_REG: 0X00000000
Jul 27 15:19:27 x201 kernel: iwlagn
0000:02:00.0: Start IWL Event Log Dump: display last 20 entries
Jul 27
15:19:27 x201 kernel: iwlagn 0000:02:00.0:
EVT_LOGT:0000005631:0x000000ff:1100
Jul 27 15:19:27 x201 kernel: iwlagn
0000:02:00.0: EVT_LOGT:0000005631:0x000000ff:1100
Jul 27 15:19:27 x201
kernel: iwlagn 0000:02:00.0: EVT_LOGT:0000005632:0x000000ff:1100
Jul 27
15:19:27 x201 kernel: iwlagn 0000:02:00.0:
EVT_LOGT:0000005633:0x000000ff:1100
Jul 27 15:19:27 x201 kernel: iwlagn
0000:02:00.0: EVT_LOGT:0000005633:0x000000ff:1100
Jul 27 15:19:27 x201
kernel: iwlagn 0000:02:00.0: EVT_LOGT:0000005634:0x000000ff:1100
Jul 27
15:19:27 x201 kernel: iwlagn 0000:02:00.0:
EVT_LOGT:0000005635:0x000000ff:1100
Jul 27 15:19:27 x201 kernel: iwlagn
0000:02:00.0: EVT_LOGT:0000005636:0x000000ff:1100
Jul 27 15:19:27 x201
kernel: iwlagn 0000:02:00.0: EVT_LOGT:0000005637:0x000000ff:1100
Jul 27
15:19:27 x201 kernel: iwlagn 0000:02:00.0:
EVT_LOGT:0000005638:0x000000ff:1100
Jul 27 15:19:27 x201 kernel: iwlagn
0000:02:00.0: EVT_LOGT:0000005639:0x000000ff:1100
Jul 27 15:19:27 x201
kernel: iwlagn 0000:02:00.0: EVT_LOGT:0000005640:0x000000ff:1100
Jul 27
15:19:27 x201 kernel: iwlagn 0000:02:00.0:
EVT_LOGT:0000005640:0x000000ff:1100
Jul 27 15:19:27 x201 kernel: iwlagn
0000:02:00.0: EVT_LOGT:0000005641:0x000000ff:1100
Jul 27 15:19:27 x201
kernel: iwlagn 0000:02:00.0: EVT_LOGT:0000005642:0x000000ff:1100
Jul 27
15:19:27 x201 kernel: iwlagn 0000:02:00.0:
EVT_LOGT:0000013014:0x0400005a:0401
Jul 27 15:19:27 x201 kernel: iwlagn
0000:02:00.0: EVT_LOGT:0000013015:0x0400005a:1513
Jul 27 15:19:27 x201
kernel: iwlagn 0000:02:00.0: EVT_LOGT:0000013016:0x00000000:1513
Jul 27
15:19:27 x201 kernel: iwlagn 0000:02:00.0:
EVT_LOGT:0000013017:0x00000001:1523
Jul 27 15:19:27 x201 kernel: iwlagn
0000:02:00.0: EVT_LOGT:0000013132:0x00000000:0125
Jul 27 15:19:27 x201
kernel: iwlagn 0000:02:00.0: Command REPLY_PHY_CALIBRATION_CMD failed: FW
Error
Jul 27 15:19:27 x201 kernel: iwlagn 0000:02:00.0: Error -5 iteration
0
Jul 27 15:19:27 x201 kernel: iwlagn 0000:02:00.0: Error sending
TX_ANT_CONFIGURATION_CMD: time out after 500ms.
Jul 27 15:19:28 x201 kernel:
iwlagn 0000:02:00.0: Error sending REPLY_BT_CONFIG: time out after
500ms.
Jul 27 15:19:28 x201 kernel: iwlagn 0000:02:00.0: failed to send BT
Coex Config
Jul 27 15:19:28 x201 kernel: iwlagn 0000:02:00.0: Error sending
REPLY_RXON: time out after 500ms.
Jul 27 15:19:28 x201 kernel: iwlagn
0000:02:00.0: Error setting new RXON (-110)
Jul 27 15:19:29 x201 kernel:
iwlagn 0000:02:00.0: Error sending REPLY_CT_KILL_CONFIG_CMD: time out after
500ms.
Jul 27 15:19:29 x201 kernel: iwlagn 0000:02:00.0:
REPLY_CT_KILL_CONFIG_CMD failed
Jul 27 15:19:29 x201 kernel: iwlagn
0000:02:00.0: queue 4 stuck 3 time. Fw reload.
Jul 27 15:19:29 x201 kernel:
iwlagn 0000:02:00.0: On demand firmware reload
Jul 27 15:19:29 x201 kernel:
iwlagn 0000:02:00.0: Error sending POWER_TABLE_CMD: time out after
500ms.
Jul 27 15:19:29 x201 kernel: iwlagn 0000:02:00.0: set power fail, ret
=3D -110
Jul 27 15:19:29 x201 kernel: ------------[ cut here ]------------
Jul
27 15:19:29 x201 kernel: WARNING: at
drivers/net/wireless/iwlwifi/iwl-core.c:2068
iwl_mac_add_interface+0x127/0x150 [iwlcore]()
Jul 27 15:19:29 x201 kernel:
Hardware name: 3626W6E
Jul 27 15:19:29 x201 kernel: Modules linked in: ipv6
sco bnep rfcomm l2cap tp_smapi hdaps thinkpad_ec iwlagn btusb i2400m_usb
iwlcore bluetooth i2400m mac80211 joydev wimax i2c_i801 cfg80211 nfs lockd
sunrpc scsi_wait_scan usb_storage
Jul 27 15:19:29 x201 kernel: Pid: 18,
comm: events/3 Not tainted 2.6.35-rc6-tuxonice #2
Jul 27 15:19:29 x201
kernel: Call Trace:
Jul 27 15:19:29 x201 kernel: [<ffffffff8107737a>]
warn_slowpath_common+0x7a/0xb0
Jul 27 15:19:29 x201 kernel:
[<ffffffff810773c5>] warn_slowpath_null+0x15/0x20
Jul 27 15:19:29 x201
kernel: [<ffffffffa01e0077>] iwl_mac_add_interface+0x127/0x150 [iwlcore]
Jul
27 15:19:29 x201 kernel: [<ffffffffa0123454>] ieee80211_reconfig+0x84/0x460
[mac80211]
Jul 27 15:19:29 x201 kernel: [<ffffffffa0106bc0>] ?
ieee80211_restart_work+0x0/0x30 [mac80211]
Jul 27 15:19:29 x201 kernel:
[<ffffffffa0106bdd>] ieee80211_restart_work+0x1d/0x30 [mac80211]
Jul 27
15:19:29 x201 kernel: [<ffffffff8108b8ed>] worker_thread+0x16d/0x270
Jul 27
15:19:29 x201 kernel: [<ffffffff81090060>] ?
autoremove_wake_function+0x0/0x40
Jul 27 15:19:29 x201 kernel:
[<ffffffff8108b780>] ? worker_thread+0x0/0x270
Jul 27 15:19:29 x201 kernel:
[<ffffffff8108fa3e>] kthread+0x8e/0xa0
Jul 27 15:19:29 x201 kernel:
[<ffffffff8102cb54>] kernel_thread_helper+0x4/0x10
Jul 27 15:19:29 x201
kernel: [<ffffffff8108f9b0>] ? kthread+0x0/0xa0
Jul 27 15:19:29 x201 kernel:
[<ffffffff8102cb50>] ? kernel_thread_helper+0x0/0x10
Jul 27 15:19:29 x201
kernel: ---[ end trace f89060a8b6153bf5 ]---
Jul 27 15:19:29 x201 kernel:
iwlagn 0000:02:00.0: Microcode SW error detected.  Restarting 0x2000000.
Jul
27 15:19:29 x201 kernel: iwlagn 0000:02:00.0: Loaded firmware version:
9.201.4.1 build 24255
Jul 27 15:19:29 x201 kernel: iwlagn 0000:02:00.0:
Start IWL Error Log Dump:
Jul 27 15:19:29 x201 kernel: iwlagn 0000:02:00.0:
Status: 0x00020224, count: 5
Jul 27 15:19:29 x201 kernel: iwlagn
0000:02:00.0: Desc                               Time       data1      data2
     line
Jul 27 15:19:29 x201 kernel: iwlagn 0000:02:00.0: SYSASSERT      =20
            (#05) 0000013599 0x0000008D 0x8000000D 453
Jul 27 15:19:29 x201
kernel: iwlagn 0000:02:00.0: pc      blink1  blink2  ilink1  ilink2=20
hcmd
Jul 27 15:19:29 x201 kernel: iwlagn 0000:02:00.0: 0x1EAB8 0x1EAA6
0x1EAA6 0x009D6 0x00000 0x400005A
Jul 27 15:19:29 x201 kernel: iwlagn
0000:02:00.0: CSR values:
Jul 27 15:19:29 x201 kernel: iwlagn 0000:02:00.0:
(2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
Jul 27 15:19:29
x201 kernel: iwlagn 0000:02:00.0:        CSR_HW_IF_CONFIG_REG:
0X00480303
Jul 27 15:19:29 x201 kernel: iwlagn 0000:02:00.0:        =20
CSR_INT_COALESCING: 0X0000ff40
Jul 27 15:19:29 x201 kernel: iwlagn
0000:02:00.0:                     CSR_INT: 0X00000000
Jul 27 15:19:29 x201
kernel: iwlagn 0000:02:00.0:                CSR_INT_MASK: 0X00000000
Jul 27
15:19:29 x201 kernel: iwlagn 0000:02:00.0:           CSR_FH_INT_STATUS:
0X00000000
Jul 27 15:19:29 x201 kernel: iwlagn 0000:02:00.0:               =20
CSR_GPIO_IN: 0X0000000f
Jul 27 15:19:29 x201 kernel: iwlagn 0000:02:00.0:  =20
               CSR_RESET: 0X00000000
Jul 27 15:19:29 x201 kernel: iwlagn
0000:02:00.0:                CSR_GP_CNTRL: 0X080403c5
Jul 27 15:19:29 x201
kernel: iwlagn 0000:02:00.0:                  CSR_HW_REV: 0X00000084
Jul 27
15:19:29 x201 kernel: iwlagn 0000:02:00.0:              CSR_EEPROM_REG:
0Xa0820ffd
Jul 27 15:19:29 x201 kernel: iwlagn 0000:02:00.0:             =20
CSR_EEPROM_GP: 0X90000801
Jul 27 15:19:29 x201 kernel: iwlagn 0000:02:00.0:=20
            CSR_OTP_GP_REG: 0X00030001
Jul 27 15:19:29 x201 kernel: iwlagn
0000:02:00.0:                 CSR_GIO_REG: 0X00080046
Jul 27 15:19:29 x201
kernel: iwlagn 0000:02:00.0:            CSR_GP_UCODE_REG: 0X00000002
Jul 27
15:19:29 x201 kernel: iwlagn 0000:02:00.0:           CSR_GP_DRIVER_REG:
0X00000004
Jul 27 15:19:29 x201 kernel: iwlagn 0000:02:00.0:         =20
CSR_UCODE_DRV_GP1: 0X00000000
Jul 27 15:19:29 x201 kernel: iwlagn
0000:02:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
Jul 27 15:19:29 x201
kernel: iwlagn 0000:02:00.0:                 CSR_LED_REG: 0X00000018
Jul 27
15:19:29 x201 kernel: iwlagn 0000:02:00.0:        CSR_DRAM_INT_TBL_REG:
0X880ffffe
Jul 27 15:19:29 x201 kernel: iwlagn 0000:02:00.0:      =20
CSR_GIO_CHICKEN_BITS: 0X27800200
Jul 27 15:19:29 x201 kernel: iwlagn
0000:02:00.0:             CSR_ANA_PLL_CFG: 0X00000000
Jul 27 15:19:29 x201
kernel: iwlagn 0000:02:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
Jul 27
15:19:29 x201 kernel: iwlagn 0000:02:00.0:        CSR_DBG_HPET_MEM_REG:
0Xffff0000
Jul 27 15:19:29 x201 kernel: iwlagn 0000:02:00.0: FH register
values:
Jul 27 15:19:29 x201 kernel: iwlagn 0000:02:00.0:       =20
=46H_RSCSR_CHNL0_STTS_WPTR_REG: 0X0ffede00
Jul 27 15:19:29 x201 kernel: iwlagn
0000:02:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X00ffedf0
Jul 27
15:19:29 x201 kernel: iwlagn 0000:02:00.0:                =20
=46H_RSCSR_CHNL0_WPTR: 0X00000000
Jul 27 15:19:29 x201 kernel: iwlagn
0000:02:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80819104
Jul 27
15:19:29 x201 kernel: iwlagn 0000:02:00.0:        =20
=46H_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
Jul 27 15:19:29 x201 kernel: iwlagn
0000:02:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
Jul 27
15:19:29 x201 kernel: iwlagn 0000:02:00.0:  =20
=46H_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
Jul 27 15:19:29 x201 kernel:
iwlagn 0000:02:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
Jul 27
15:19:29 x201 kernel: iwlagn 0000:02:00.0:               =20
=46H_TSSR_TX_ERROR_REG: 0X00000000
Jul 27 15:19:29 x201 kernel: iwlagn
0000:02:00.0: Start IWL Event Log Dump: display last 20 entries
Jul 27
15:19:29 x201 kernel: iwlagn 0000:02:00.0:
EVT_LOGT:0000005630:0x000000ff:1100
Jul 27 15:19:29 x201 kernel: iwlagn
0000:02:00.0: EVT_LOGT:0000005630:0x000000ff:1100
Jul 27 15:19:29 x201
kernel: iwlagn 0000:02:00.0: EVT_LOGT:0000005631:0x000000ff:1100
Jul 27
15:19:29 x201 kernel: iwlagn 0000:02:00.0:
EVT_LOGT:0000005632:0x000000ff:1100
Jul 27 15:19:29 x201 kernel: iwlagn
0000:02:00.0: EVT_LOGT:0000005632:0x000000ff:1100
Jul 27 15:19:29 x201
kernel: iwlagn 0000:02:00.0: EVT_LOGT:0000005633:0x000000ff:1100
Jul 27
15:19:29 x201 kernel: iwlagn 0000:02:00.0:
EVT_LOGT:0000005634:0x000000ff:1100
Jul 27 15:19:29 x201 kernel: iwlagn
0000:02:00.0: EVT_LOGT:0000005635:0x000000ff:1100
Jul 27 15:19:29 x201
kernel: iwlagn 0000:02:00.0: EVT_LOGT:0000005636:0x000000ff:1100
Jul 27
15:19:29 x201 kernel: iwlagn 0000:02:00.0:
EVT_LOGT:0000005637:0x000000ff:1100
Jul 27 15:19:29 x201 kernel: iwlagn
0000:02:00.0: EVT_LOGT:0000005638:0x000000ff:1100
Jul 27 15:19:29 x201
kernel: iwlagn 0000:02:00.0: EVT_LOGT:0000005638:0x000000ff:1100
Jul 27
15:19:29 x201 kernel: iwlagn 0000:02:00.0:
EVT_LOGT:0000005639:0x000000ff:1100
Jul 27 15:19:29 x201 kernel: iwlagn
0000:02:00.0: EVT_LOGT:0000005640:0x000000ff:1100
Jul 27 15:19:29 x201
kernel: iwlagn 0000:02:00.0: EVT_LOGT:0000005641:0x000000ff:1100
Jul 27
15:19:29 x201 kernel: iwlagn 0000:02:00.0:
EVT_LOGT:0000013491:0x0400005a:0401
Jul 27 15:19:29 x201 kernel: iwlagn
0000:02:00.0: EVT_LOGT:0000013492:0x0400005a:1513
Jul 27 15:19:29 x201
kernel: iwlagn 0000:02:00.0: EVT_LOGT:0000013492:0x00000000:1513
Jul 27
15:19:29 x201 kernel: iwlagn 0000:02:00.0:
EVT_LOGT:0000013493:0x00000001:1523
Jul 27 15:19:29 x201 kernel: iwlagn
0000:02:00.0: EVT_LOGT:0000013608:0x00000000:0125
Jul 27 15:19:29 x201
kernel: iwlagn 0000:02:00.0: Command REPLY_PHY_CALIBRATION_CMD failed: FW
Error
Jul 27 15:19:29 x201 kernel: iwlagn 0000:02:00.0: Error -5 iteration
0
Jul 27 15:19:30 x201 kernel: iwlagn 0000:02:00.0: Error sending
TX_ANT_CONFIGURATION_CMD: time out after 500ms.
Jul 27 15:19:30 x201 kernel:
iwlagn 0000:02:00.0: Error sending REPLY_BT_CONFIG: time out after
500ms.
Jul 27 15:19:30 x201 kernel: iwlagn 0000:02:00.0: failed to send BT
Coex Config
Jul 27 15:19:31 x201 kernel: iwlagn 0000:02:00.0: Error sending
REPLY_RXON: time out after 500ms.
Jul 27 15:19:31 x201 kernel: iwlagn
0000:02:00.0: Error setting new RXON (-110)
Jul 27 15:19:31 x201 kernel:
iwlagn 0000:02:00.0: Error sending REPLY_CT_KILL_CONFIG_CMD: time out after
500ms.
Jul 27 15:19:31 x201 kernel: iwlagn 0000:02:00.0:
REPLY_CT_KILL_CONFIG_CMD failed
Jul 27 15:19:31 x201 kernel: iwlagn
0000:02:00.0: queue 4 stuck 3 time. Fw reload.
Jul 27 15:19:32 x201 kernel:
iwlagn 0000:02:00.0: Error sending POWER_TABLE_CMD: time out after
500ms.
Jul 27 15:19:32 x201 kernel: iwlagn 0000:02:00.0: set power fail, ret
=3D -110
Jul 27 15:19:32 x201 kernel: ------------[ cut here ]------------
Jul
27 15:19:32 x201 kernel: WARNING: at
drivers/net/wireless/iwlwifi/iwl-core.c:2068
iwl_mac_add_interface+0x127/0x150 [iwlcore]()
Jul 27 15:19:32 x201 kernel:
Hardware name: 3626W6E
Jul 27 15:19:32 x201 kernel: Modules linked in: ipv6
sco bnep rfcomm l2cap tp_smapi hdaps thinkpad_ec iwlagn btusb i2400m_usb
iwlcore bluetooth i2400m mac80211 joydev wimax i2c_i801 cfg80211 nfs lockd
sunrpc scsi_wait_scan usb_storage
Jul 27 15:19:32 x201 kernel: Pid: 16,
comm: events/1 Tainted: G        W   2.6.35-rc6-tuxonice #2
Jul 27 15:19:32
x201 kernel: Call Trace:
Jul 27 15:19:32 x201 kernel: [<ffffffff8107737a>]
warn_slowpath_common+0x7a/0xb0
Jul 27 15:19:32 x201 kernel:
[<ffffffff810773c5>] warn_slowpath_null+0x15/0x20
Jul 27 15:19:32 x201
kernel: [<ffffffffa01e0077>] iwl_mac_add_interface+0x127/0x150 [iwlcore]
Jul
27 15:19:32 x201 kernel: [<ffffffffa0123454>] ieee80211_reconfig+0x84/0x460
[mac80211]
Jul 27 15:19:32 x201 kernel: [<ffffffffa0106bc0>] ?
ieee80211_restart_work+0x0/0x30 [mac80211]
Jul 27 15:19:32 x201 kernel:
[<ffffffffa0106bdd>] ieee80211_restart_work+0x1d/0x30 [mac80211]
Jul 27
15:19:32 x201 kernel: [<ffffffff8108b8ed>] worker_thread+0x16d/0x270
Jul 27
15:19:32 x201 kernel: [<ffffffff81090060>] ?
autoremove_wake_function+0x0/0x40
Jul 27 15:19:32 x201 kernel:
[<ffffffff8108b780>] ? worker_thread+0x0/0x270
Jul 27 15:19:32 x201 kernel:
[<ffffffff8108fa3e>] kthread+0x8e/0xa0
Jul 27 15:19:32 x201 kernel:
[<ffffffff8102cb54>] kernel_thread_helper+0x4/0x10
Jul 27 15:19:32 x201
kernel: [<ffffffff8108f9b0>] ? kthread+0x0/0xa0
Jul 27 15:19:32 x201 kernel:
[<ffffffff8102cb50>] ? kernel_thread_helper+0x0/0x10
Jul 27 15:19:32 x201
kernel: ---[ end trace f89060a8b6153bf6 ]---
Jul 27 15:19:32 x201 kernel:
iwlagn 0000:02:00.0: Microcode SW error detected.  Restarting 0x2000000.
Jul
27 15:19:32 x201 kernel: iwlagn 0000:02:00.0: Loaded firmware version:
9.201.4.1 build 24255
Jul 27 15:19:32 x201 kernel: iwlagn 0000:02:00.0:
Start IWL Error Log Dump:
Jul 27 15:19:32 x201 kernel: iwlagn 0000:02:00.0:
Status: 0x00020224, count: 5
Jul 27 15:19:32 x201 kernel: iwlagn
0000:02:00.0: Desc                               Time       data1      data2
     line
Jul 27 15:19:32 x201 kernel: iwlagn 0000:02:00.0: SYSASSERT      =20
            (#05) 0000012798 0x0000008D 0x8000000D 453
Jul 27 15:19:32 x201
kernel: iwlagn 0000:02:00.0: pc      blink1  blink2  ilink1  ilink2=20
hcmd
Jul 27 15:19:32 x201 kernel: iwlagn 0000:02:00.0: 0x1EAB8 0x1EAA6
0x1EAA6 0x009D6 0x00000 0x400005A
Jul 27 15:19:32 x201 kernel: iwlagn
0000:02:00.0: CSR values:
Jul 27 15:19:32 x201 kernel: iwlagn 0000:02:00.0:
(2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
Jul 27 15:19:32
x201 kernel: iwlagn 0000:02:00.0:        CSR_HW_IF_CONFIG_REG:
0X00480303
Jul 27 15:19:32 x201 kernel: iwlagn 0000:02:00.0:        =20
CSR_INT_COALESCING: 0X0000ff40
Jul 27 15:19:32 x201 kernel: iwlagn
0000:02:00.0:                     CSR_INT: 0X00000000
Jul 27 15:19:32 x201
kernel: iwlagn 0000:02:00.0:                CSR_INT_MASK: 0X00000000
Jul 27
15:19:32 x201 kernel: iwlagn 0000:02:00.0:           CSR_FH_INT_STATUS:
0X00000000
Jul 27 15:19:32 x201 kernel: iwlagn 0000:02:00.0:               =20
CSR_GPIO_IN: 0X0000000f
Jul 27 15:19:32 x201 kernel: iwlagn 0000:02:00.0:  =20
               CSR_RESET: 0X00000000
Jul 27 15:19:32 x201 kernel: iwlagn
0000:02:00.0:                CSR_GP_CNTRL: 0X080403c5
Jul 27 15:19:32 x201
kernel: iwlagn 0000:02:00.0:                  CSR_HW_REV: 0X00000084
Jul 27
15:19:32 x201 kernel: iwlagn 0000:02:00.0:              CSR_EEPROM_REG:
0Xa0820ffd
Jul 27 15:19:32 x201 kernel: iwlagn 0000:02:00.0:             =20
CSR_EEPROM_GP: 0X90000801
Jul 27 15:19:32 x201 kernel: iwlagn 0000:02:00.0:=20
            CSR_OTP_GP_REG: 0X00030001
Jul 27 15:19:32 x201 kernel: iwlagn
0000:02:00.0:                 CSR_GIO_REG: 0X00080046
Jul 27 15:19:32 x201
kernel: iwlagn 0000:02:00.0:            CSR_GP_UCODE_REG: 0X00000002
Jul 27
15:19:32 x201 kernel: iwlagn 0000:02:00.0:           CSR_GP_DRIVER_REG:
0X00000004
Jul 27 15:19:32 x201 kernel: iwlagn 0000:02:00.0:         =20
CSR_UCODE_DRV_GP1: 0X00000000
Jul 27 15:19:32 x201 kernel: iwlagn
0000:02:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
Jul 27 15:19:32 x201
kernel: iwlagn 0000:02:00.0:                 CSR_LED_REG: 0X00000018
Jul 27
15:19:32 x201 kernel: iwlagn 0000:02:00.0:        CSR_DRAM_INT_TBL_REG:
0X880ffffe
Jul 27 15:19:32 x201 kernel: iwlagn 0000:02:00.0:      =20
CSR_GIO_CHICKEN_BITS: 0X27800200
Jul 27 15:19:32 x201 kernel: iwlagn
0000:02:00.0:             CSR_ANA_PLL_CFG: 0X00000000
Jul 27 15:19:32 x201
kernel: iwlagn 0000:02:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
Jul 27
15:19:32 x201 kernel: iwlagn 0000:02:00.0:        CSR_DBG_HPET_MEM_REG:
0Xffff0000
Jul 27 15:19:32 x201 kernel: iwlagn 0000:02:00.0: FH register
values:
Jul 27 15:19:32 x201 kernel: iwlagn 0000:02:00.0:       =20
=46H_RSCSR_CHNL0_STTS_WPTR_REG: 0X0ffede00
Jul 27 15:19:32 x201 kernel: iwlagn
0000:02:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X00ffedf0
Jul 27
15:19:32 x201 kernel: iwlagn 0000:02:00.0:                =20
=46H_RSCSR_CHNL0_WPTR: 0X00000000
Jul 27 15:19:32 x201 kernel: iwlagn
0000:02:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80819104
Jul 27
15:19:32 x201 kernel: iwlagn 0000:02:00.0:        =20
=46H_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
Jul 27 15:19:32 x201 kernel: iwlagn
0000:02:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
Jul 27
15:19:32 x201 kernel: iwlagn 0000:02:00.0:  =20
=46H_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
Jul 27 15:19:32 x201 kernel:
iwlagn 0000:02:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
Jul 27
15:19:32 x201 kernel: iwlagn 0000:02:00.0:               =20
=46H_TSSR_TX_ERROR_REG: 0X00000000
Jul 27 15:19:32 x201 kernel: iwlagn
0000:02:00.0: Start IWL Event Log Dump: display last 20 entries
Jul 27
15:19:32 x201 kernel: iwlagn 0000:02:00.0:
EVT_LOGT:0000005629:0x000000ff:1100
Jul 27 15:19:32 x201 kernel: iwlagn
0000:02:00.0: EVT_LOGT:0000005630:0x000000ff:1100
Jul 27 15:19:32 x201
kernel: iwlagn 0000:02:00.0: EVT_LOGT:0000005631:0x000000ff:1100
Jul 27
15:19:32 x201 kernel: iwlagn 0000:02:00.0:
EVT_LOGT:0000005632:0x000000ff:1100
Jul 27 15:19:32 x201 kernel: iwlagn
0000:02:00.0: EVT_LOGT:0000005632:0x000000ff:1100
Jul 27 15:19:32 x201
kernel: iwlagn 0000:02:00.0: EVT_LOGT:0000005633:0x000000ff:1100
Jul 27
15:19:32 x201 kernel: iwlagn 0000:02:00.0:
EVT_LOGT:0000005634:0x000000ff:1100
Jul 27 15:19:32 x201 kernel: iwlagn
0000:02:00.0: EVT_LOGT:0000005635:0x000000ff:1100
Jul 27 15:19:32 x201
kernel: iwlagn 0000:02:00.0: EVT_LOGT:0000005636:0x000000ff:1100
Jul 27
15:19:32 x201 kernel: iwlagn 0000:02:00.0:
EVT_LOGT:0000005637:0x000000ff:1100
Jul 27 15:19:32 x201 kernel: iwlagn
0000:02:00.0: EVT_LOGT:0000005638:0x000000ff:1100
Jul 27 15:19:32 x201
kernel: iwlagn 0000:02:00.0: EVT_LOGT:0000005638:0x000000ff:1100
Jul 27
15:19:32 x201 kernel: iwlagn 0000:02:00.0:
EVT_LOGT:0000005639:0x000000ff:1100
Jul 27 15:19:32 x201 kernel: iwlagn
0000:02:00.0: EVT_LOGT:0000005640:0x000000ff:1100
Jul 27 15:19:32 x201
kernel: iwlagn 0000:02:00.0: EVT_LOGT:0000005640:0x000000ff:1100
Jul 27
15:19:32 x201 kernel: iwlagn 0000:02:00.0:
EVT_LOGT:0000012690:0x0400005a:0401
Jul 27 15:19:32 x201 kernel: iwlagn
0000:02:00.0: EVT_LOGT:0000012691:0x0400005a:1513
Jul 27 15:19:32 x201
kernel: iwlagn 0000:02:00.0: EVT_LOGT:0000012692:0x00000000:1513
Jul 27
15:19:32 x201 kernel: iwlagn 0000:02:00.0:
EVT_LOGT:0000012693:0x00000001:1523
Jul 27 15:19:32 x201 kernel: iwlagn
0000:02:00.0: EVT_LOGT:0000012807:0x00000000:0125
Jul 27 15:19:32 x201
kernel: iwlagn 0000:02:00.0: Command REPLY_PHY_CALIBRATION_CMD failed: FW
Error
Jul 27 15:19:32 x201 kernel: iwlagn 0000:02:00.0: Error -5 iteration
0
Jul 27 15:19:32 x201 kernel: iwlagn 0000:02:00.0: Error sending
TX_ANT_CONFIGURATION_CMD: time out after 500ms.
Jul 27 15:19:33 x201 kernel:
iwlagn 0000:02:00.0: Error sending REPLY_BT_CONFIG: time out after
500ms.
Jul 27 15:19:33 x201 kernel: iwlagn 0000:02:00.0: failed to send BT
Coex Config
Jul 27 15:19:33 x201 kernel: iwlagn 0000:02:00.0: Error sending
REPLY_RXON: time out after 500ms.
Jul 27 15:19:33 x201 kernel: iwlagn
0000:02:00.0: Error setting new RXON (-110)
Jul 27 15:19:34 x201 kernel:
iwlagn 0000:02:00.0: Error sending REPLY_CT_KILL_CONFIG_CMD: time out after
500ms.
Jul 27 15:19:34 x201 kernel: iwlagn 0000:02:00.0:
REPLY_CT_KILL_CONFIG_CMD failed
Jul 27 15:19:34 x201 kernel: iwlagn
0000:02:00.0: queue 4 stuck 3 time. Fw reload.
Jul 27 15:19:34 x201 kernel:
iwlagn 0000:02:00.0: On demand firmware reload
Jul 27 15:19:34 x201 kernel:
iwlagn 0000:02:00.0: Error sending POWER_TABLE_CMD: time out after
500ms.
Jul 27 15:19:34 x201 kernel: iwlagn 0000:02:00.0: set power fail, ret
=3D -110
Jul 27 15:19:34 x201 kernel: ------------[ cut here ]------------
Jul
27 15:19:34 x201 kernel: WARNING: at
drivers/net/wireless/iwlwifi/iwl-core.c:2068
iwl_mac_add_interface+0x127/0x150 [iwlcore]()
Jul 27 15:19:34 x201 kernel:
Hardware name: 3626W6E
Jul 27 15:19:34 x201 kernel: Modules linked in: ipv6
sco bnep rfcomm l2cap tp_smapi hdaps thinkpad_ec iwlagn btusb i2400m_usb
iwlcore bluetooth i2400m mac80211 joydev wimax i2c_i801 cfg80211 nfs lockd
sunrpc scsi_wait_scan usb_storage
Jul 27 15:19:34 x201 kernel: Pid: 17,
comm: events/2 Tainted: G        W   2.6.35-rc6-tuxonice #2
Jul 27 15:19:34
x201 kernel: Call Trace:
Jul 27 15:19:34 x201 kernel: [<ffffffff8107737a>]
warn_slowpath_common+0x7a/0xb0
Jul 27 15:19:34 x201 kernel:
[<ffffffff810773c5>] warn_slowpath_null+0x15/0x20
Jul 27 15:19:34 x201
kernel: [<ffffffffa01e0077>] iwl_mac_add_interface+0x127/0x150 [iwlcore]
Jul
27 15:19:34 x201 kernel: [<ffffffffa0123454>] ieee80211_reconfig+0x84/0x460
[mac80211]
Jul 27 15:19:34 x201 kernel: [<ffffffffa0106bc0>] ?
ieee80211_restart_work+0x0/0x30 [mac80211]
Jul 27 15:19:34 x201 kernel:
[<ffffffffa0106bdd>] ieee80211_restart_work+0x1d/0x30 [mac80211]
Jul 27
15:19:34 x201 kernel: [<ffffffff8108b8ed>] worker_thread+0x16d/0x270
Jul 27
15:19:34 x201 kernel: [<ffffffff81090060>] ?
autoremove_wake_function+0x0/0x40
Jul 27 15:19:34 x201 kernel:
[<ffffffff8108b780>] ? worker_thread+0x0/0x270
Jul 27 15:19:34 x201 kernel:
[<ffffffff8108fa3e>] kthread+0x8e/0xa0
Jul 27 15:19:34 x201 kernel:
[<ffffffff8102cb54>] kernel_thread_helper+0x4/0x10
Jul 27 15:19:34 x201
kernel: [<ffffffff8108f9b0>] ? kthread+0x0/0xa0
Jul 27 15:19:34 x201 kernel:
[<ffffffff8102cb50>] ? kernel_thread_helper+0x0/0x10
Jul 27 15:19:34 x201
kernel: ---[ end trace f89060a8b6153bf7 ]---
Jul 27 15:19:34 x201 kernel:
iwlagn 0000:02:00.0: Microcode SW error detected.  Restarting 0x2000000.
Jul
27 15:19:34 x201 kernel: iwlagn 0000:02:00.0: Loaded firmware version:
9.201.4.1 build 24255
Jul 27 15:19:34 x201 kernel: iwlagn 0000:02:00.0:
Start IWL Error Log Dump:
Jul 27 15:19:34 x201 kernel: iwlagn 0000:02:00.0:
Status: 0x00020224, count: 5
Jul 27 15:19:34 x201 kernel: iwlagn
0000:02:00.0: Desc                               Time       data1      data2
     line
Jul 27 15:19:34 x201 kernel: iwlagn 0000:02:00.0: SYSASSERT      =20
            (#05) 0000013662 0x0000008D 0x8000000D 453
Jul 27 15:19:34 x201
kernel: iwlagn 0000:02:00.0: pc      blink1  blink2  ilink1  ilink2=20
hcmd
Jul 27 15:19:34 x201 kernel: iwlagn 0000:02:00.0: 0x1EAB8 0x1EAA6
0x1EAA6 0x009D6 0x00000 0x400005A
Jul 27 15:19:34 x201 kernel: iwlagn
0000:02:00.0: CSR values:
Jul 27 15:19:34 x201 kernel: iwlagn 0000:02:00.0:
(2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
Jul 27 15:19:34
x201 kernel: iwlagn 0000:02:00.0:        CSR_HW_IF_CONFIG_REG:
0X00480303
Jul 27 15:19:34 x201 kernel: iwlagn 0000:02:00.0:        =20
CSR_INT_COALESCING: 0X0000ff40
Jul 27 15:19:34 x201 kernel: iwlagn
0000:02:00.0:                     CSR_INT: 0X00000000
Jul 27 15:19:34 x201
kernel: iwlagn 0000:02:00.0:                CSR_INT_MASK: 0X00000000
Jul 27
15:19:34 x201 kernel: iwlagn 0000:02:00.0:           CSR_FH_INT_STATUS:
0X00000000
Jul 27 15:19:34 x201 kernel: iwlagn 0000:02:00.0:               =20
CSR_GPIO_IN: 0X0000000f
Jul 27 15:19:34 x201 kernel: iwlagn 0000:02:00.0:  =20
               CSR_RESET: 0X00000000
Jul 27 15:19:34 x201 kernel: iwlagn
0000:02:00.0:                CSR_GP_CNTRL: 0X080403c5
Jul 27 15:19:34 x201
kernel: iwlagn 0000:02:00.0:                  CSR_HW_REV: 0X00000084
Jul 27
15:19:34 x201 kernel: iwlagn 0000:02:00.0:              CSR_EEPROM_REG:
0Xa0820ffd
Jul 27 15:19:34 x201 kernel: iwlagn 0000:02:00.0:             =20
CSR_EEPROM_GP: 0X90000801
Jul 27 15:19:34 x201 kernel: iwlagn 0000:02:00.0:=20
            CSR_OTP_GP_REG: 0X00030001
Jul 27 15:19:34 x201 kernel: iwlagn
0000:02:00.0:                 CSR_GIO_REG: 0X00080046
Jul 27 15:19:34 x201
kernel: iwlagn 0000:02:00.0:            CSR_GP_UCODE_REG: 0X00000002
Jul 27
15:19:34 x201 kernel: iwlagn 0000:02:00.0:           CSR_GP_DRIVER_REG:
0X00000004
Jul 27 15:19:34 x201 kernel: iwlagn 0000:02:00.0:         =20
CSR_UCODE_DRV_GP1: 0X00000000
Jul 27 15:19:34 x201 kernel: iwlagn
0000:02:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
Jul 27 15:19:34 x201
kernel: iwlagn 0000:02:00.0:                 CSR_LED_REG: 0X00000018
Jul 27
15:19:34 x201 kernel: iwlagn 0000:02:00.0:        CSR_DRAM_INT_TBL_REG:
0X880ffffe
Jul 27 15:19:34 x201 kernel: iwlagn 0000:02:00.0:      =20
CSR_GIO_CHICKEN_BITS: 0X27800200
Jul 27 15:19:34 x201 kernel: iwlagn
0000:02:00.0:             CSR_ANA_PLL_CFG: 0X00000000
Jul 27 15:19:34 x201
kernel: iwlagn 0000:02:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
Jul 27
15:19:34 x201 kernel: iwlagn 0000:02:00.0:        CSR_DBG_HPET_MEM_REG:
0Xffff0000
Jul 27 15:19:34 x201 kernel: iwlagn 0000:02:00.0: FH register
values:
Jul 27 15:19:34 x201 kernel: iwlagn 0000:02:00.0:       =20
=46H_RSCSR_CHNL0_STTS_WPTR_REG: 0X0ffede00
Jul 27 15:19:34 x201 kernel: iwlagn
0000:02:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X00ffedf0
Jul 27
15:19:34 x201 kernel: iwlagn 0000:02:00.0:                =20
=46H_RSCSR_CHNL0_WPTR: 0X00000000
Jul 27 15:19:34 x201 kernel: iwlagn
0000:02:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80819104
Jul 27
15:19:34 x201 kernel: iwlagn 0000:02:00.0:        =20
=46H_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
Jul 27 15:19:34 x201 kernel: iwlagn
0000:02:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
Jul 27
15:19:34 x201 kernel: iwlagn 0000:02:00.0:  =20
=46H_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
Jul 27 15:19:34 x201 kernel:
iwlagn 0000:02:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
Jul 27
15:19:34 x201 kernel: iwlagn 0000:02:00.0:               =20
=46H_TSSR_TX_ERROR_REG: 0X00000000
Jul 27 15:19:34 x201 kernel: iwlagn
0000:02:00.0: Start IWL Event Log Dump: display last 20 entries
Jul 27
15:19:34 x201 kernel: iwlagn 0000:02:00.0:
EVT_LOGT:0000005629:0x000000ff:1100
Jul 27 15:19:34 x201 kernel: iwlagn
0000:02:00.0: EVT_LOGT:0000005630:0x000000ff:1100
Jul 27 15:19:34 x201
kernel: iwlagn 0000:02:00.0: EVT_LOGT:0000005631:0x000000ff:1100
Jul 27
15:19:34 x201 kernel: iwlagn 0000:02:00.0:
EVT_LOGT:0000005632:0x000000ff:1100
Jul 27 15:19:34 x201 kernel: iwlagn
0000:02:00.0: EVT_LOGT:0000005632:0x000000ff:1100
Jul 27 15:19:34 x201
kernel: iwlagn 0000:02:00.0: EVT_LOGT:0000005633:0x000000ff:1100
Jul 27
15:19:34 x201 kernel: iwlagn 0000:02:00.0:
EVT_LOGT:0000005634:0x000000ff:1100
Jul 27 15:19:34 x201 kernel: iwlagn
0000:02:00.0: EVT_LOGT:0000005635:0x000000ff:1100
Jul 27 15:19:34 x201
kernel: iwlagn 0000:02:00.0: EVT_LOGT:0000005636:0x000000ff:1100
Jul 27
15:19:34 x201 kernel: iwlagn 0000:02:00.0:
EVT_LOGT:0000005637:0x000000ff:1100
Jul 27 15:19:34 x201 kernel: iwlagn
0000:02:00.0: EVT_LOGT:0000005638:0x000000ff:1100
Jul 27 15:19:34 x201
kernel: iwlagn 0000:02:00.0: EVT_LOGT:0000005638:0x000000ff:1100
Jul 27
15:19:34 x201 kernel: iwlagn 0000:02:00.0:
EVT_LOGT:0000005639:0x000000ff:1100
Jul 27 15:19:34 x201 kernel: iwlagn
0000:02:00.0: EVT_LOGT:0000005640:0x000000ff:1100
Jul 27 15:19:34 x201
kernel: iwlagn 0000:02:00.0: EVT_LOGT:0000005640:0x000000ff:1100
Jul 27
15:19:34 x201 kernel: iwlagn 0000:02:00.0:
EVT_LOGT:0000013554:0x0400005a:0401
Jul 27 15:19:34 x201 kernel: iwlagn
0000:02:00.0: EVT_LOGT:0000013555:0x0400005a:1513
Jul 27 15:19:34 x201
kernel: iwlagn 0000:02:00.0: EVT_LOGT:0000013555:0x00000000:1513
Jul 27
15:19:34 x201 kernel: iwlagn 0000:02:00.0:
EVT_LOGT:0000013556:0x00000001:1523
Jul 27 15:19:34 x201 kernel: iwlagn
0000:02:00.0: EVT_LOGT:0000013671:0x00000000:0125
Jul 27 15:19:34 x201
kernel: iwlagn 0000:02:00.0: Command REPLY_PHY_CALIBRATION_CMD failed: FW
Error
Jul 27 15:19:34 x201 kernel: iwlagn 0000:02:00.0: Error -5 iteration
0
Jul 27 15:19:35 x201 kernel: iwlagn 0000:02:00.0: Error sending
TX_ANT_CONFIGURATION_CMD: time out after 500ms.
Jul 27 15:19:35 x201 kernel:
iwlagn 0000:02:00.0: Error sending REPLY_BT_CONFIG: time out after
500ms.
Jul 27 15:19:35 x201 kernel: iwlagn 0000:02:00.0: failed to send BT
Coex Config
Jul 27 15:19:36 x201 kernel: iwlagn 0000:02:00.0: Error sending
REPLY_RXON: time out after 500ms.
Jul 27 15:19:36 x201 kernel: iwlagn
0000:02:00.0: Error setting new RXON (-110)
Jul 27 15:19:36 x201 kernel:
iwlagn 0000:02:00.0: Error sending REPLY_CT_KILL_CONFIG_CMD: time out after
500ms.
Jul 27 15:19:36 x201 kernel: iwlagn 0000:02:00.0:
REPLY_CT_KILL_CONFIG_CMD failed
Jul 27 15:19:36 x201 kernel: iwlagn
0000:02:00.0: queue 4 stuck 3 time. Fw reload.
Jul 27 15:19:37 x201 kernel:
iwlagn 0000:02:00.0: Error sending POWER_TABLE_CMD: time out after
500ms.
Jul 27 15:19:37 x201 kernel: iwlagn 0000:02:00.0: set power fail, ret
=3D -110
Jul 27 15:19:37 x201 kernel: iwlagn 0000:02:00.0: Error sending
REPLY_RXON: time out after 500ms.
Jul 27 15:19:37 x201 kernel: iwlagn
0000:02:00.0: Error setting new RXON (-110)
Jul 27 15:19:38 x201 kernel:
iwlagn 0000:02:00.0: Error sending REPLY_RXON: time out after 500ms.
Jul 27
15:19:38 x201 kernel: iwlagn 0000:02:00.0: Error setting new RXON (-110)
Jul
27 15:19:38 x201 kernel: iwlagn 0000:02:00.0: Error sending REPLY_RXON: time
out after 500ms.
Jul 27 15:19:38 x201 kernel: iwlagn 0000:02:00.0: Error
setting new RXON (-110)
Jul 27 15:19:39 x201 kernel: iwlagn 0000:02:00.0:
Error sending REPLY_RXON: time out after 500ms.
Jul 27 15:19:39 x201 kernel:
iwlagn 0000:02:00.0: Error setting new RXON (-110)
Jul 27 15:19:39 x201
kernel: iwlagn 0000:02:00.0: Microcode SW error detected.  Restarting
0x2000000.
Jul 27 15:19:39 x201 kernel: iwlagn 0000:02:00.0: Loaded firmware
version: 9.201.4.1 build 24255
Jul 27 15:19:39 x201 kernel: iwlagn
0000:02:00.0: Start IWL Error Log Dump:
Jul 27 15:19:39 x201 kernel: iwlagn
0000:02:00.0: Status: 0x00020224, count: 5
Jul 27 15:19:39 x201 kernel:
iwlagn 0000:02:00.0: Desc                               Time       data1   =
=20
 data2      line
Jul 27 15:19:39 x201 kernel: iwlagn 0000:02:00.0: SYSASSERT
                   (#05) 0000013754 0x0000008D 0x8000000D 453
Jul 27
15:19:39 x201 kernel: iwlagn 0000:02:00.0: pc      blink1  blink2  ilink1=20
ilink2  hcmd
Jul 27 15:19:39 x201 kernel: iwlagn 0000:02:00.0: 0x1EAB8
0x1EAA6 0x1EAA6 0x009D6 0x00000 0x400005A
Jul 27 15:19:39 x201 kernel:
iwlagn 0000:02:00.0: CSR values:
Jul 27 15:19:39 x201 kernel: iwlagn
0000:02:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
Jul
27 15:19:39 x201 kernel: iwlagn 0000:02:00.0:        CSR_HW_IF_CONFIG_REG:
0X00480303
Jul 27 15:19:39 x201 kernel: iwlagn 0000:02:00.0:        =20
CSR_INT_COALESCING: 0X0000ff40
Jul 27 15:19:39 x201 kernel: iwlagn
0000:02:00.0:                     CSR_INT: 0X00000000
Jul 27 15:19:39 x201
kernel: iwlagn 0000:02:00.0:                CSR_INT_MASK: 0X00000000
Jul 27
15:19:39 x201 kernel: iwlagn 0000:02:00.0:           CSR_FH_INT_STATUS:
0X00000000
Jul 27 15:19:39 x201 kernel: iwlagn 0000:02:00.0:               =20
CSR_GPIO_IN: 0X0000000f
Jul 27 15:19:39 x201 kernel: iwlagn 0000:02:00.0:  =20
               CSR_RESET: 0X00000000Jul 27 15:19:39 x201 kernel: iwlagn
0000:02:00.0:                CSR_GP_CNTRL: 0X080403c5
Jul 27 15:19:39 x201
kernel: iwlagn 0000:02:00.0:                  CSR_HW_REV: 0X00000084
Jul 27
15:19:39 x201 kernel: iwlagn 0000:02:00.0:              CSR_EEPROM_REG:
0Xa0820ffd
Jul 27 15:19:39 x201 kernel: iwlagn 0000:02:00.0:             =20
CSR_EEPROM_GP: 0X90000801
Jul 27 15:19:39 x201 kernel: iwlagn 0000:02:00.0:=20
            CSR_OTP_GP_REG: 0X00030001
Jul 27 15:19:39 x201 kernel: iwlagn
0000:02:00.0:                 CSR_GIO_REG: 0X00080046
Jul 27 15:19:39 x201
kernel: iwlagn 0000:02:00.0:            CSR_GP_UCODE_REG: 0X00000002
Jul 27
15:19:39 x201 kernel: iwlagn 0000:02:00.0:           CSR_GP_DRIVER_REG:
0X00000004
Jul 27 15:19:39 x201 kernel: iwlagn 0000:02:00.0:         =20
CSR_UCODE_DRV_GP1: 0X00000000
Jul 27 15:19:39 x201 kernel: iwlagn
0000:02:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
Jul 27 15:19:39 x201
kernel: iwlagn 0000:02:00.0:                 CSR_LED_REG: 0X00000018
Jul 27
15:19:39 x201 kernel: iwlagn 0000:02:00.0:        CSR_DRAM_INT_TBL_REG:
0X880ffffe
Jul 27 15:19:39 x201 kernel: iwlagn 0000:02:00.0:      =20
CSR_GIO_CHICKEN_BITS: 0X27800200
Jul 27 15:19:39 x201 kernel: iwlagn
0000:02:00.0:             CSR_ANA_PLL_CFG: 0X00000000
Jul 27 15:19:39 x201
kernel: iwlagn 0000:02:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
Jul 27
15:19:39 x201 kernel: iwlagn 0000:02:00.0:        CSR_DBG_HPET_MEM_REG:
0Xffff0000
Jul 27 15:19:39 x201 kernel: iwlagn 0000:02:00.0: FH register
values:
Jul 27 15:19:39 x201 kernel: iwlagn 0000:02:00.0:       =20
=46H_RSCSR_CHNL0_STTS_WPTR_REG: 0X0ffede00
Jul 27 15:19:39 x201 kernel: iwlagn
0000:02:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X00ffedf0
Jul 27
15:19:39 x201 kernel: iwlagn 0000:02:00.0:                =20
=46H_RSCSR_CHNL0_WPTR: 0X00000000
Jul 27 15:19:39 x201 kernel: iwlagn
0000:02:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80819104
Jul 27
15:19:39 x201 kernel: iwlagn 0000:02:00.0:        =20
=46H_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
Jul 27 15:19:39 x201 kernel: iwlagn
0000:02:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
Jul 27
15:19:39 x201 kernel: iwlagn 0000:02:00.0:  =20
=46H_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
Jul 27 15:19:39 x201 kernel:
iwlagn 0000:02:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
Jul 27
15:19:39 x201 kernel: iwlagn 0000:02:00.0:               =20
=46H_TSSR_TX_ERROR_REG: 0X00000000
Jul 27 15:19:39 x201 kernel: iwlagn
0000:02:00.0: Start IWL Event Log Dump: display last 20 entries
Jul 27
15:19:39 x201 kernel: iwlagn 0000:02:00.0:
EVT_LOGT:0000005631:0x000000ff:1100
Jul 27 15:19:39 x201 kernel: iwlagn
0000:02:00.0: EVT_LOGT:0000005631:0x000000ff:1100
Jul 27 15:19:39 x201
kernel: iwlagn 0000:02:00.0: EVT_LOGT:0000005632:0x000000ff:1100
Jul 27
15:19:39 x201 kernel: iwlagn 0000:02:00.0:
EVT_LOGT:0000005633:0x000000ff:1100
Jul 27 15:19:39 x201 kernel: iwlagn
0000:02:00.0: EVT_LOGT:0000005633:0x000000ff:1100
Jul 27 15:19:39 x201
kernel: iwlagn 0000:02:00.0: EVT_LOGT:0000005634:0x000000ff:1100
Jul 27
15:19:39 x201 kernel: iwlagn 0000:02:00.0:
EVT_LOGT:0000005635:0x000000ff:1100
Jul 27 15:19:39 x201 kernel: iwlagn
0000:02:00.0: EVT_LOGT:0000005636:0x000000ff:1100
Jul 27 15:19:39 x201
kernel: iwlagn 0000:02:00.0: EVT_LOGT:0000005637:0x000000ff:1100
Jul 27
15:19:39 x201 kernel: iwlagn 0000:02:00.0:
EVT_LOGT:0000005638:0x000000ff:1100
Jul 27 15:19:39 x201 kernel: iwlagn
0000:02:00.0: EVT_LOGT:0000005639:0x000000ff:1100
Jul 27 15:19:39 x201
kernel: iwlagn 0000:02:00.0: EVT_LOGT:0000005639:0x000000ff:1100
Jul 27
15:19:39 x201 kernel: iwlagn 0000:02:00.0:
EVT_LOGT:0000005640:0x000000ff:1100
Jul 27 15:19:39 x201 kernel: iwlagn
0000:02:00.0: EVT_LOGT:0000005641:0x000000ff:1100
Jul 27 15:19:39 x201
kernel: iwlagn 0000:02:00.0: EVT_LOGT:0000005642:0x000000ff:1100
Jul 27
15:19:39 x201 kernel: iwlagn 0000:02:00.0:
EVT_LOGT:0000013647:0x0400005a:0401
Jul 27 15:19:39 x201 kernel: iwlagn
0000:02:00.0: EVT_LOGT:0000013648:0x0400005a:1513
Jul 27 15:19:39 x201
kernel: iwlagn 0000:02:00.0: EVT_LOGT:0000013648:0x00000000:1513
Jul 27
15:19:39 x201 kernel: iwlagn 0000:02:00.0:
EVT_LOGT:0000013650:0x00000001:1523
Jul 27 15:19:39 x201 kernel: iwlagn
0000:02:00.0: EVT_LOGT:0000013764:0x00000000:0125
Jul 27 15:19:39 x201
kernel: iwlagn 0000:02:00.0: Command REPLY_PHY_CALIBRATION_CMD failed: FW
Error
Jul 27 15:19:39 x201 kernel: iwlagn 0000:02:00.0: Error -5 iteration
0
Jul 27 15:19:39 x201 kernel: iwlagn 0000:02:00.0: Error sending
TX_ANT_CONFIGURATION_CMD: time out after 500ms.
Jul 27 15:19:40 x201 kernel:
iwlagn 0000:02:00.0: Error sending REPLY_BT_CONFIG: time out after
500ms.
Jul 27 15:19:40 x201 kernel: iwlagn 0000:02:00.0: failed to send BT
Coex Config
Jul 27 15:19:40 x201 kernel: iwlagn 0000:02:00.0: Error sending
REPLY_RXON: time out after 500ms.
Jul 27 15:19:40 x201 kernel: iwlagn
0000:02:00.0: Error setting new RXON (-110)
Jul 27 15:19:41 x201 kernel:
iwlagn 0000:02:00.0: Error sending REPLY_CT_KILL_CONFIG_CMD: time out after
500ms.
Jul 27 15:19:41 x201 kernel: iwlagn 0000:02:00.0:
REPLY_CT_KILL_CONFIG_CMD failed
Jul 27 15:19:41 x201 kernel: iwlagn
0000:02:00.0: queue 4 stuck 3 time. Fw reload.
Jul 27 15:19:41 x201 kernel:
iwlagn 0000:02:00.0: On demand firmware reload
Jul 27 15:19:41 x201 kernel:
iwlagn 0000:02:00.0: Error sending POWER_TABLE_CMD: time out after
500ms.
Jul 27 15:19:41 x201 kernel: iwlagn 0000:02:00.0: set power fail, ret
=3D -110
Jul 27 15:19:41 x201 kernel: ------------[ cut here ]------------
Jul
27 15:19:41 x201 kernel: WARNING: at
drivers/net/wireless/iwlwifi/iwl-core.c:2068
iwl_mac_add_interface+0x127/0x150 [iwlcore]()
Jul 27 15:19:41 x201 kernel:
Hardware name: 3626W6E
Jul 27 15:19:41 x201 kernel: Modules linked in: ipv6
sco bnep rfcomm l2cap tp_smapi hdaps thinkpad_ec iwlagn btusb i2400m_usb
iwlcore bluetooth i2400m mac80211 joydev wimax i2c_i801 cfg80211 nfs lockd
sunrpc scsi_wait_scan usb_storage
Jul 27 15:19:41 x201 kernel: Pid: 16,
comm: events/1 Tainted: G        W   2.6.35-rc6-tuxonice #2
Jul 27 15:19:41
x201 kernel: Call Trace:
Jul 27 15:19:41 x201 kernel: [<ffffffff8107737a>]
warn_slowpath_common+0x7a/0xb0
Jul 27 15:19:41 x201 kernel:
[<ffffffff810773c5>] warn_slowpath_null+0x15/0x20
Jul 27 15:19:41 x201
kernel: [<ffffffffa01e0077>] iwl_mac_add_interface+0x127/0x150 [iwlcore]
Jul
27 15:19:41 x201 kernel: [<ffffffffa0123454>] ieee80211_reconfig+0x84/0x460
[mac80211]
Jul 27 15:19:41 x201 kernel: [<ffffffffa0106bc0>] ?
ieee80211_restart_work+0x0/0x30 [mac80211]
Jul 27 15:19:41 x201 kernel:
[<ffffffffa0106bdd>] ieee80211_restart_work+0x1d/0x30 [mac80211]
Jul 27
15:19:41 x201 kernel: [<ffffffff8108b8ed>] worker_thread+0x16d/0x270
Jul 27
15:19:41 x201 kernel: [<ffffffff81090060>] ?
autoremove_wake_function+0x0/0x40
Jul 27 15:19:41 x201 kernel:
[<ffffffff8108b780>] ? worker_thread+0x0/0x270
Jul 27 15:19:41 x201 kernel:
[<ffffffff8108fa3e>] kthread+0x8e/0xa0
Jul 27 15:19:41 x201 kernel:
[<ffffffff8102cb54>] kernel_thread_helper+0x4/0x10
Jul 27 15:19:41 x201
kernel: [<ffffffff8108f9b0>] ? kthread+0x0/0xa0
Jul 27 15:19:41 x201 kernel:
[<ffffffff8102cb50>] ? kernel_thread_helper+0x0/0x10
Jul 27 15:19:41 x201
kernel: ---[ end trace f89060a8b6153bf8 ]---
Jul 27 15:19:41 x201 kernel:
iwlagn 0000:02:00.0: Microcode SW error detected.  Restarting 0x2000000.
Jul
27 15:19:41 x201 kernel: iwlagn 0000:02:00.0: Loaded firmware version:
9.201.4.1 build 24255
Jul 27 15:19:41 x201 kernel: iwlagn 0000:02:00.0:
Start IWL Error Log Dump:
Jul 27 15:19:41 x201 kernel: iwlagn 0000:02:00.0:
Status: 0x00020224, count: 5
Jul 27 15:19:41 x201 kernel: iwlagn
0000:02:00.0: Desc                               Time       data1      data2
     line
Jul 27 15:19:41 x201 kernel: iwlagn 0000:02:00.0: SYSASSERT      =20
            (#05) 0000012923 0x0000008D 0x8000000D 453
Jul 27 15:19:41 x201
kernel: iwlagn 0000:02:00.0: pc      blink1  blink2  ilink1  ilink2=20
hcmd



=2D-=20
Best Regards,
Alexey 'Alexxy' Shvetsov
Petersburg Nuclear
Physics Institute, Russia
Department of Molecular and Radiation
Biophysics
Gentoo Team Ru
Gentoo Linux
Dev
mailto:alexxyum@gmail.com
mailto:alexxy@gentoo.org
mailto:alexxy@omrb.pn
pi.spb.ru

--nextPart2316676.jduGYeo2zY
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEABECAAYFAkxQbr4ACgkQ5BmOA85PVLh4EgCdH80zPIOpDnhpTvt/+3nfVtSz
FQ8An1bnxKGW4tYZRHwlKMxnz7jVcEii
=pPPS
-----END PGP SIGNATURE-----

--nextPart2316676.jduGYeo2zY--
