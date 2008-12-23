Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vm01.vehosting.nl ([85.17.51.140]:52410 "EHLO VM01.VEHosting.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149AbYLWUv4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2008 15:51:56 -0500
Message-ID: <49514A65.3060604@amsat.org> (sfid-20081223_215213_815974_DD7D7953)
Date: Tue, 23 Dec 2008 21:30:29 +0100
From: Jeroen Vreeken <pe1rxq@amsat.org>
MIME-Version: 1.0
To: David Kilroy <kilroyd@googlemail.com>
CC: linux-wireless@vger.kernel.org, simon@thekelleys.org.uk,
	jussi.kivilinna@mbnet.fi, acme@ghostprotocols.net
Subject: Re: [PATCH] wireless: Add channel/frequency conversions to ieee80211.h
References: <1230041018-13341-1-git-send-email-kilroyd@googlemail.com>
In-Reply-To: <1230041018-13341-1-git-send-email-kilroyd@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Kilroy wrote:
> Added mappings for FHSS, DSSS and OFDM channels - with macros to point
> HR DSSS and ERP to the DSSS mappings. Currently just static inline
> functions.
>
> Use the new functions in the older fullmac drivers. This eliminates a
> number of const static buffers and removes a couple of range checks that
> are now redundant.
>
> Signed-off-by: David Kilroy <kilroyd@googlemail.com>
>   
Hi David,

The zd1201 stuff seems fine to me.

Acked-by: Jeroen Vreeken <pe1rxq@amsat.org>


Regards,
Jeroen
