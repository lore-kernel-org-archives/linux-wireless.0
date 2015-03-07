Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58765 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750744AbbCGFdu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Mar 2015 00:33:50 -0500
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Joe Perches <joe@perches.com>
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net
Subject: Re: [PATCH 1/1] New driver: rtl8723au (mac80211)
References: <1425680126-25928-1-git-send-email-Jes.Sorensen@redhat.com>
	<1425680126-25928-2-git-send-email-Jes.Sorensen@redhat.com>
	<1425682797.12017.58.camel@perches.com>
	<wrfj7futwfl5.fsf@ultrasam.lan.trained-monkey.org>
	<1425705814.12017.68.camel@perches.com>
Date: Sat, 07 Mar 2015 00:33:41 -0500
In-Reply-To: <1425705814.12017.68.camel@perches.com> (Joe Perches's message of
	"Fri, 06 Mar 2015 21:23:34 -0800")
Message-ID: <wrfjioedv0ay.fsf@ultrasam.lan.trained-monkey.org> (sfid-20150307_063353_976162_0895A3AE)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Joe Perches <joe@perches.com> writes:
> On Sat, 2015-03-07 at 00:18 -0500, Jes Sorensen wrote:
>> The long strings are an outright nack.
>
> Pity.  There's a specific exclusion in CodingStyle.
>
> 	Chapter 2: Breaking long lines and strings
>
> never break user-visible strings such as
> printk messages, because that breaks the ability to grep for them.

I know some people like this, and I disagree with this rule! I wrote
this driver, and I am the one maintaining it.

I love receiving fixes for bugs, but this is not a bug!

If you wrote a piece of code, I wouldn't question how you prefer to
maintain it.

Jes
