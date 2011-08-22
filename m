Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:64915 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480Ab1HVQsr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Aug 2011 12:48:47 -0400
Received: by gya6 with SMTP id 6so3702447gya.19
        for <linux-wireless@vger.kernel.org>; Mon, 22 Aug 2011 09:48:47 -0700 (PDT)
Message-ID: <4E52886C.6050608@lwfinger.net> (sfid-20110822_184851_376961_7B379FFD)
Date: Mon, 22 Aug 2011 11:48:44 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: mohammed <mohammed@qca.qualcomm.com>
CC: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	rodrigue@qca.qualcomm.com, senthilb@qca.qualcomm.com,
	rmanohar@qca.qualcomm.com
Subject: Re: [PATCH] ath9k_htc: Fix few possible memory leaks
References: <1313942085-6238-1-git-send-email-mohammed@qca.qualcomm.com> <20110822052918.GA30951@vasanth-laptop> <4E525FF7.6070904@qca.qualcomm.com>
In-Reply-To: <4E525FF7.6070904@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/22/2011 08:56 AM, mohammed wrote:
>
>
> Vasanth thanks for your review, I haven't and not aware of that code
> flow/callback. I will check into that.
>

This patch has helped a lot, but after about 12 hours of running, I still have 
18 leaks found. I will try to sort them out.

Larry
