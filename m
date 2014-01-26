Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:33858 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbaAZANN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Jan 2014 19:13:13 -0500
Received: by mail-ob0-f178.google.com with SMTP id wn1so5070844obc.23
        for <linux-wireless@vger.kernel.org>; Sat, 25 Jan 2014 16:13:13 -0800 (PST)
Message-ID: <52E45317.9060508@lwfinger.net> (sfid-20140126_011337_926013_907CEF39)
Date: Sat, 25 Jan 2014 18:13:11 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Connor Behan <connor.behan@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] Remove executable permissions from firmware files
References: <1390691946-6612-1-git-send-email-connor.behan@gmail.com>
In-Reply-To: <1390691946-6612-1-git-send-email-connor.behan@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/25/2014 05:19 PM, Connor Behan wrote:
> We should change these permissions unless there is a reason to keep them
> executable.
>
> Signed-off-by: Connor Behan <connor.behan@gmail.com>
> ---

I have no problem with making this change. I had not done so for the rtlwifi 
files as it just looks like churning the firmware.

A bigger problem is that this is not the correct place to submit patches for 
linux-firmware. I do Cc linux-wireless, but the patches should also be sent to 
David Woodhouse <dwmw2@infradead.org>, and Ben Hutchings <ben@decadent.org.uk> 
with a Cc to netdev@vger.kernel.org.

Larry

