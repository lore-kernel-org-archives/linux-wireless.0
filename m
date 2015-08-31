Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:35355 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885AbbHaRtk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Aug 2015 13:49:40 -0400
Received: by wibq14 with SMTP id q14so7833583wib.0
        for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2015 10:49:39 -0700 (PDT)
Message-ID: <55E493B1.7020004@gmail.com> (sfid-20150831_194944_573977_DF827499)
Date: Mon, 31 Aug 2015 19:49:37 +0200
From: Arend van Spriel <aspriel@gmail.com>
MIME-Version: 1.0
To: Kuei Hao Liu <alanliu@qca.qualcomm.com>, kvalo@qca.qualcomm.com
CC: ath6kl-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3] *** Add wmi-tlv support in test mode ***
References: <1441043051-14107-1-git-send-email-alanliu@qca.qualcomm.com>
In-Reply-To: <1441043051-14107-1-git-send-email-alanliu@qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 31-08-15 19:44, Kuei Hao Liu wrote:
> *** BLURB HERE ***

For a single patch I would not bother adding cover letter.

Regards,
Arend

> alanliu (1):
>   Add wmi-tlv support in test mode
> 
>  drivers/net/wireless/ath/ath10k/core.c     |   4 +-
>  drivers/net/wireless/ath/ath10k/core.h     |   5 +-
>  drivers/net/wireless/ath/ath10k/testmode.c | 123 ++++++++++++++++++++++++++---
>  drivers/net/wireless/ath/ath10k/wmi-tlv.c  |  15 +++-
>  4 files changed, 131 insertions(+), 16 deletions(-)
> 
