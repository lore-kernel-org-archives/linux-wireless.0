Return-Path: <SRS0=E2P1=NN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: **
X-Spam-Status: No, score=2.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,UNWANTED_LANGUAGE_BODY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFDDCC32789
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Nov 2018 08:54:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 51C572082D
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Nov 2018 08:54:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 51C572082D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=erdw.ethz.ch
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726316AbeKBSAc convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 2 Nov 2018 14:00:32 -0400
Received: from edge20.ethz.ch ([82.130.99.26]:22113 "EHLO edge20.ethz.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725843AbeKBSAc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Nov 2018 14:00:32 -0400
X-Greylist: delayed 366 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Nov 2018 14:00:31 EDT
Received: from mailm216.d.ethz.ch (129.132.139.40) by edge20.ethz.ch
 (82.130.99.26) with Microsoft SMTP Server (TLS) id 14.3.408.0; Fri, 2 Nov
 2018 09:47:57 +0100
Received: from DESKTOPDN35N2P (178.196.111.147) by mailm216.d.ethz.ch
 (2001:67c:10ec:5603::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1531.3; Fri, 2 Nov 2018
 09:47:52 +0100
From:   =?utf-8?Q?Michael_K=C3=B6bberich?= 
        <michael.koebberich@erdw.ethz.ch>
To:     <linuxwifi@intel.com>, <linux-wireless@vger.kernel.org>
Subject: iwlwifi firmware
Date:   Fri, 2 Nov 2018 09:47:55 +0100
Message-ID: <005001d47288$bf86fac0$3e94f040$@erdw.ethz.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AdRyiLZ0HOJgzFWnS0+saXkYAT9bOA==
Content-Language: de-ch
X-Originating-IP: [178.196.111.147]
X-ClientProxiedBy: mailm114.d.ethz.ch (2001:67c:10ec:5602::26) To
 mailm216.d.ethz.ch (2001:67c:10ec:5603::30)
X-TM-SNTS-SMTP: 728A12B6D7BCF3FD57161A1967A1A2A4FE3AA882B576AE24190434C2BA4BB11A2000:8
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Sehr geehrtes Intel Team

Ich bin auf der Suche nach Firmware für einen Axxiv FIN NUC DH17012, genauer gesagt dessen WIFI Karte. Sind die Treiber:

iwlwifi-8000C-26.ucode
iwlwifi-8000C-25.ucode
iwlwifi-8000C-24.ucode
iwlwifi-8000C-23.ucode
iwlwifi-8000C-22.ucode
iwlwifi-8000C-21.ucode
iwlwifi-8000C-20.ucode
iwlwifi-8000C-19.ucode
iwlwifi-8000C-18.ucode
iwlwifi-8000C-17.ucode

bei Ihnen erhältlich?

Mit freundlichen Grüssen

Michael Köbberich, Dr. sc. ETH

