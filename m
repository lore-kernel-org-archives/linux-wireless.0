Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f52.google.com ([209.85.215.52]:41636 "EHLO
        mail-lf0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753124AbeE3LyV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 May 2018 07:54:21 -0400
Received: by mail-lf0-f52.google.com with SMTP id d24-v6so3832792lfa.8
        for <linux-wireless@vger.kernel.org>; Wed, 30 May 2018 04:54:20 -0700 (PDT)
Subject: Re: Research + questions on brcmfmac and support for monitor mode
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        brcm80211-dev-list.pdl@broadcom.com, brcm80211-dev-list@cypress.com
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <986bbf4c-8fa1-4367-db9e-76a209594b81@gmail.com>
Message-ID: <66e43eb5-2bc9-2ec3-af48-03248eecb727@gmail.com> (sfid-20180530_135428_190308_8B3481C6)
Date: Wed, 30 May 2018 13:52:31 +0200
MIME-Version: 1.0
In-Reply-To: <986bbf4c-8fa1-4367-db9e-76a209594b81@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm providing extra version info of tested firmware images as requested
by Arend in another e-mail thread.

On 15.05.2018 14:29, Rafał Miłecki wrote:
> 1) brcmfmac43602-pcie.ap.bin from linux-firmware.git
> Firmware version = wl0: Sep 18 2015 03:30:01 version 7.35.177.56 (r587209) FWID 01-6cb8e269
> 
> Monitor frames without raiotap
> 
> flags: 0x0001
> 
> Extra caps: mbss4 ndoe proptxstatus

43602a1-roml/pcie-ag-splitrx-fdap-mbss-mfp-wl11k-wl11u-txbf-pktctx-amsdutx-ampduretry-chkd2hdma-proptxstatus-11nprop Version: 7.35.177.56 CRC: 548eccd4 Date: Fri 2015-09-18 03:31:06 PDT Ucode Ver: 986.122 FWID: 01-6cb8e269


> 2) brcmfmac4366b-pcie.bin from linux-firmware.git
> Firmware version = wl0: Jan  8 2016 12:54:07 version 10.10.69.3309 (r610991) FWID 01-c47a91a4
> 
> Monitor frames without raiotap
> 
> flags: 0x0001
> 
> Extra caps: ccx mbss8 multi-user-beamformer proptxstatus
> single-user-beamformee single-user-beamformer toe txpwrcache

4366b1-roml/pcie-ag-splitrx-fdap-mbss-mfp-wnm-osen-wl11k-wl11u-txbf-pktctx-amsdutx-ampduretry-chkd2hdma-proptxstatus-11nprop-obss-dbwsw-ringer-dmaindex16-bgdfs Version: 10.10.69.237 CRC: 4bc48c7b Date: Fri 2016-01-08 12:55:25 PST Ucode Ver: 1073.531 FWID: 01-c47a91a4


> 3) 4366b1 development branch (from Arend)
> Firmware version = wl0: Oct  6 2016 10:17:32 version 10.10 (TOB) (r663589) FWID 01-6c5a1687
> 
> Monitor frames without raiotap
> 
> flags: 0x0001
> 
> Extra caps: bgdfs ccx mbss8 multi-user-beamformer proptxstatus
> single-user-beamformee single-user-beamformer toe txpwrcache

4366b1-roml/pcie-ag-splitrx-fdap-mbss-mfp-wnm-osen-wl11k-wl11u-txbf-pktctx-amsdutx-ampduretry-chkd2hdma-proptxstatus-11nprop-obss-dbwsw-ringer-dmaindex16-bgdfs Version: 10.10 (TOB) (r663589) CRC: 50d4be62 Date: Thu 2016-10-06 10:46:42 BST Ucode Ver: 1128.155 FWID: 01-6c5a1687

> 4) brcmfmac4366c-pcie.bin.k3
> Firmware version = wl0: Aug 19 2016 15:22:35 version 10.10.69.74 (r629731 WLTEST) FWID 01-5c0166fa
> 
> Monitor frames without raiotap
> 
> flags: 0x0001
> 
> Extra caps: bgdfs ccx cptlv-4 mbss8 multi-user-beamformee
> multi-user-beamformer single-user-beamformee single-user-beamformer toe
> txpwrcache

4366c0-roml/pcie-ag-splitrx-fdap-mbss-mfgtest-seqcmds-phydbg-phydump-txbf-pktctx-amsdutx-ampduretry-chkd2hdma-11nprop-dbgam-dbgams-ringer-dmaindex16-bgdfs-hostpmac Version: 10.10.69.74 CRC: a6268b76 Date: Mon 2016-09-12 16:39:23 CST FWID 01-5c0166fa


> 5) brcmfmac4366c-pcie.bin.ea9500
> Firmware version = wl0: Aug 23 2016 17:19:51 version 10.10.69.69 (r625687) FWID 01-8438621f
> 
> Monitor frames without raiotap
> 
> flags: 0x0001
> 
> Extra caps: bgdfs ccx mbss8 multi-user-beamformee multi-user-beamformer
> proptxstatus single-user-beamformee single-user-beamformer toe
> txpwrcache

4366c0-roml/pcie-ag-splitrx-fdap-mbss-mfp-wnm-osen-wl11k-wl11u-txbf-pktctx-amsdutx-ampduretry-chkd2hdma-proptxstatus-11nprop-obss-dbwsw-ringer-dmaindex16-bgdfs-hostpmac Version: 10.10.69.69 CRC: 34d30c8c Date: Tue 2016-08-23 17:31:24 PDT FWID 01-8438621f


> 6) brcmfmac4366c-pcie.bin.ac88u
> Firmware version = wl0: Sep 12 2016 13:26:44 version 10.10.69.6908 (r658761) FWID 01-fed440e1
> 
> Monitor frames without raiotap
> 
> flags: 0x0001
> 
> Extra caps: bgdfs ccx cptlv-4 mbss8 multi-user-beamformee
> multi-user-beamformer proptxstatus single-user-beamformee
> single-user-beamformer toe txpwrcache

4366c0-roml/pcie-ag-splitrx-fdap-mbss-mfp-wnm-osen-wl11k-wl11u-txbf-pktctx-amsdutx-ampduretry-chkd2hdma-proptxstatus-11nprop-obss-dbwsw-ringer-dmaindex16-bgdfs-hostpmac-txpwr Version: 10.10.69.252 CRC: 9fa88ab1 Date: Mon 2016-09-12 13:28:49 CST Ucode Ver: 1073.579 FWID: 01-fed440e1


> 7) brcmfmac4366c-pcie.bin.asus-dhd24
> Firmware version = wl0: Nov  7 2017 12:23:08 version 10.10.69.69017 (r730013) FWID 01-e258597c
> 
> Monitor frames include radiotap header
> 
> flags: 0x0002
> 
> Extra caps: bgdfs ccx cptlv-4 mbss8 multi-user-beamformee
> multi-user-beamformer proptxstatus single-user-beamformee
> single-user-beamformer toe txpwrcache

4366c0-roml/pcie-ag-splitrx-fdap-mbss-mfp-wnm-osen-wl11k-wl11u-txbf-pktctx-amsdutx-ampduretry-chkd2hdma-proptxstatus-11nprop-obss-dbwsw-ringer-dmaindex16-bgdfs-hostpmac-txpwr-stamon Version: 10.10.69.69017 (r730013) CRC: cf0b5621 Date: Tue 2017-11-07 12:34:00 CST Ucode Ver: 1073.579 FWID: 01-e258597c


> 8) 4366c0 fw from FW_EA9500v2_EA9500S_2.1.1.183171_prod.img
> Firmware version = wl0: Aug  2 2017 18:45:13 version 10.10.122.20 (r683106) FWID 01-91326ac8
> 
> Monitor frames include radiotap header
> 
> flags: 0x0002
> 
> Extra caps: 160 bgdfs ccx dyn160 mbss8 multi-user-beamformee
> multi-user-beamformer proptxstatus single-user-beamformee
> single-user-beamformer toe txpwrcache

4366c0-roml/pcie-ag-splitrx-fdap-mbss-mfp-wnm-osen-wl11k-wl11u-txbf-pktctx-amsdutx-ampduretry-chkd2hdma-proptxstatus-11nprop-obss-dbwsw-ringer-dmaindex16-bgdfs-stamon-hostpmac-murx-splitassoc-hostmemucode-dyn160-dhdhdr Version: 10.10.122.20 CRC: c3ff28b5 Date: Wed 2017-08-02 18:58:48 PDT FWID 01-91326ac8


> 9) 4366c0 fw from GT-AC5300_3.0.0.4_382_15984-gf481f58_cferom_ubi_0824.w
> Firmware version = wl0: Aug 17 2017 08:13:19 version 10.10.122.20 (r683106) FWID 01-bbb1a4c
> 
> Monitor frames include radiotap header
> 
> flags: 0x0002
> 
> Extra caps: 160 bgdfs ccx cptlv-4 dyn160 mbss8 multi-user-beamformee
> multi-user-beamformer proptxstatus single-user-beamformee
> single-user-beamformer toe txpwrcache

4366c0-roml/pcie-ag-splitrx-fdap-mbss-mfp-wnm-osen-wl11k-wl11u-txbf-pktctx-amsdutx-ampduretry-chkd2hdma-proptxstatus-11nprop-obss-dbwsw-ringer-dmaindex16-bgdfs-stamon-hostpmac-murx-splitassoc-hostmemucode-dyn160-dhdhdr Version: 10.10.122.20 CRC: af9bda7b Date: Thu 2017-08-17 08:21:56 CST FWID 01-bbb1a4c


> 10) 4366c0 fw from ArcherC5400X(US)_171023.bin
> Firmware version = wl0: Sep 14 2017 14:10:23 version 10.10.122.20 (r683106) FWID 01-9f0e64f9
> 
> Monitor frames include radiotap header
> 
> flags: 0x0002
> 
> Extra caps: 160 bgdfs ccx dyn160 mbss8 multi-user-beamformee
> multi-user-beamformer proptxstatus single-user-beamformee
> single-user-beamformer toe txpwrcache

4366c0-roml/pcie-ag-splitrx-fdap-mbss-mfp-wnm-osen-wl11k-wl11u-txbf-pktctx-amsdutx-ampduretry-chkd2hdma-proptxstatus-11nprop-obss-dbwsw-ringer-dmaindex16-bgdfs-stamon-hostpmac-murx-splitassoc-hostmemucode-dyn160-dhdhdr Version: 10.10.122.20 CRC: fe843f10 Date: Mon 2017-10-23 17:10:00 CST FWID 01-9f0e64f9
