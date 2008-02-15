Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:63284 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754591AbYBOX3j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2008 18:29:39 -0500
Received: by fg-out-1718.google.com with SMTP id e21so626042fga.17
        for <linux-wireless@vger.kernel.org>; Fri, 15 Feb 2008 15:29:37 -0800 (PST)
Message-ID: <47B6205E.9030807@gmail.com> (sfid-20080215_232942_819904_98D574BB)
Date: Sat, 16 Feb 2008 00:29:34 +0100
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: linville@tuxdriver.com, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	Nick Kossifidis <mickflemm@gmail.com>
Subject: Re: [PATCH 2/3] WDEV, ath5k, don't return int from bool function
References: <1203109133-32217-1-git-send-email-jirislaby@gmail.com>	 <1203109133-32217-2-git-send-email-jirislaby@gmail.com>	 <43e72e890802151408g35fa2e49r5eb8557e4a5bbce4@mail.gmail.com>	 <47B61473.7060206@gmail.com> <43e72e890802151524q4690f589hcc29ea8645b1d843@mail.gmail.com>
In-Reply-To: <43e72e890802151524q4690f589hcc29ea8645b1d843@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/16/2008 12:24 AM, Luis R. Rodriguez wrote:
> On Fri, Feb 15, 2008 at 5:38 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
>> You mean to consider 0 as supported, -ENODEV/-EOPNOTSUPP as
>>  unsupported and the rest as error?
>>
> 
> Yeap, what do you think?

I have no opinion in this case, which one do you (all) like more?
