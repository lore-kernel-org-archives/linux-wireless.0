Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:13058 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbZCOCrE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Mar 2009 22:47:04 -0400
Received: by ey-out-2122.google.com with SMTP id 25so786813eya.37
        for <linux-wireless@vger.kernel.org>; Sat, 14 Mar 2009 19:47:02 -0700 (PDT)
Message-ID: <49BC6C21.6020807@gmail.com> (sfid-20090315_034717_232279_CEDCCC6C)
Date: Sun, 15 Mar 2009 03:46:57 +0100
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
CC: linux-wireless@vger.kernel.org
Subject: Re: ids missing in ath5k ?
References: <49BC0DBE.90209@gmail.com>
In-Reply-To: <49BC0DBE.90209@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Xose Vazquez Perez wrote:

> why these ids are not supported in ath5k ? 
> 
>        { 0x168c, 0x101a, PCI_ANY_ID, PCI_ANY_ID }, /* some Griffin-Lite */
>        { 0x168c, 0x9013, PCI_ANY_ID, PCI_ANY_ID }, /* sonicwall */
> 
> 
> They are included in madwifi driver! Are there more of them missing ?

another one is  { 0x168c, 0xff1a, PCI_ANY_ID, PCI_ANY_ID }, included by openwrt:
(make atheros wifi cards used on arcaydian 4519 ifxmips based boards work)

-thanks-

regards,
-- 
Polycommander, Erkowit, Urquiola, Andros Patria, Cason, Aegean Sea, Prestige, ...
