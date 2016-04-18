Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48931 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808AbcDRQHQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2016 12:07:16 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Joe Perches <joe@perches.com>
Cc: linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
	Larry.Finger@lwfinger.net
Subject: Re: [PATCH 00/16] rtl8xxxu prepare for splitting into multiple files
References: <1460994576-24091-1-git-send-email-Jes.Sorensen@redhat.com>
	<1460995000.1917.5.camel@perches.com>
Date: Mon, 18 Apr 2016 12:07:14 -0400
In-Reply-To: <1460995000.1917.5.camel@perches.com> (Joe Perches's message of
	"Mon, 18 Apr 2016 08:56:40 -0700")
Message-ID: <wrfjoa96hpe5.fsf@redhat.com> (sfid-20160418_180722_569991_E92E70A4)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Joe Perches <joe@perches.com> writes:
> On Mon, 2016-04-18 at 11:49 -0400, Jes.Sorensen@redhat.com wrote:
>> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>> 
>> Hi,
>> 
>> This is the last set of patches I have in my queue for the rtl8xxxu
>> driver, as of today :)
>> 
>> Since the driver has grown to support quite a number of different
>> chips, I want to split it into multiple files. This will make it
>> easier to maintain and also eaiser to add support for more chips
>> without having to constantly touch the core files.
>> 
>> This set renames a bunch of functions to indicate that they are
>> generic rather than chip specific. I will look at doing the actual
>> moving around in a set right after the current merge window closes.
>
> It's a bit of a pity that the identifiers are all
> quite long.  Using these long identifiers makes
> 80 column content a bit right shifted and single
> line statements unlikely.

Well I do agree that some of the names are long and I try to keep them
as short as possible when I can. However I refuse to turn this into a
NetBSD driver :)

Jes
