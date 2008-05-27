Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.234]:39583 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757007AbYE0HK7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2008 03:10:59 -0400
Received: by rv-out-0506.google.com with SMTP id l9so2793490rvb.1
        for <linux-wireless@vger.kernel.org>; Tue, 27 May 2008 00:10:59 -0700 (PDT)
Message-ID: <b25c3fa70805270010r10b7b29brd6c67ef9a0253e66@mail.gmail.com> (sfid-20080527_091114_094447_3F259758)
Date: Tue, 27 May 2008 00:10:59 -0700
From: "Joonwoo Park" <joonwpark81@gmail.com>
To: "Tomas Winkler" <tomasw@gmail.com>
Subject: Re: [PATCH] iwlwifi: fix oops on wep key insertion
Cc: "Zhu Yi" <yi.zhu@intel.com>,
	"Reinette Chatre" <reinette.chatre@intel.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240805262341s62f017e7ka7502cbe55c1d348@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1211865214-1640-1-git-send-email-joonwpark81@gmail.com>
	 <1ba2fa240805262341s62f017e7ka7502cbe55c1d348@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/5/26 Tomas Winkler <tomasw@gmail.com>:
> On Tue, May 27, 2008 at 8:13 AM, Joonwoo Park <joonwpark81@gmail.com> wrote:
>> Fix overflow which is occured by long wep key configuring.
>> Also, this patch contains some cleanup for not to do memcpy with
>> zero size.
>>
>> $sudo iwconfig wlan0 enc AAAA-AAAA-AAAA-AAAA-AAAA-AAAA-AAAA-AAAA-AAAA-AAAA-AAAA-AAAA-AAAA-AAAA-AAAA-AAAA
>>
>
> WEP key is of fixed size 13 or  5 bytes, this setting should be
> refused somewhere in the mac wext handler.
> NACK.
> Tomas
>

It sounds reasonable. I'll dig this problem more.

Thanks,
Joonwoo
