Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f208.google.com ([209.85.219.208]:37076 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321AbZJWTFm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2009 15:05:42 -0400
Received: by ewy4 with SMTP id 4so1931899ewy.37
        for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2009 12:05:46 -0700 (PDT)
Message-ID: <4AE1FE7F.2090309@gmail.com>
Date: Fri, 23 Oct 2009 20:05:35 +0100
From: Dave <kilroyd@googlemail.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC v2 0/5] orinoco: use cfg80211 for key manipulation
References: <1250640253-18434-1-git-send-email-kilroyd@googlemail.com>	 <20090831175932.GC5631@tuxdriver.com> <b88bb1ad0909121654w43215f60lf9d7b90d4b54bf35@mail.gmail.com>
In-Reply-To: <b88bb1ad0909121654w43215f60lf9d7b90d4b54bf35@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dave Kilroy wrote:
> On Tue, Sep 1, 2009 at 5:59 AM, John W. Linville <linville@tuxdriver.com> wrote:
>> On Wed, Aug 19, 2009 at 01:04:08AM +0100, David Kilroy wrote:
>>> This series basically works (at least after the last patch is applied)

>> Any word on this series?  Time is short for 2.6.32...
> 
> I'm on holiday right now, but will be back in a week.

FYI I haven't had much time to look at this lately, and will definitely
not be able to do anything with it in the next month. So this will
probably slip another release.

Current status: I've addressed Johannes' comments, and reworked things
so cfg80211 would scan if it doesn't find the bss struct after
connecting. Unfortunately it's not working and I haven't found the time
for a proper debugging session.


Dave.
