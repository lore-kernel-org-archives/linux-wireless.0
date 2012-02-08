Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34392 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755217Ab2BHSOK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Feb 2012 13:14:10 -0500
Received: by yenm8 with SMTP id m8so403586yen.19
        for <linux-wireless@vger.kernel.org>; Wed, 08 Feb 2012 10:14:09 -0800 (PST)
Message-ID: <4F32BB6E.1020803@lwfinger.net> (sfid-20120208_191415_135438_5F673A45)
Date: Wed, 08 Feb 2012 12:14:06 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: lina <lina.lastname@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: something about compact-wireless
References: <CAG9cJmnuyjxLFe5Wc4okDmOw4ik0aC_vT8xi5rEhfUJGbiczcg@mail.gmail.com>
In-Reply-To: <CAG9cJmnuyjxLFe5Wc4okDmOw4ik0aC_vT8xi5rEhfUJGbiczcg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/08/2012 11:05 AM, lina wrote:
> Hi,
>
> The question i am going to ask might sounds silly, please forgive,
>
> do I need the compact-wireless in future? something about it's history?

Obviously, you do not understand the reason for compat-wireless. It is used to 
backport the wireless drivers in the development kernels so that they can be 
used on older kernels. Whether you need it depends on what kernel you are using, 
and what device(s) you have. The short answer is "probably not".

Larry

