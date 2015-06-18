Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49235 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbbFROmj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jun 2015 10:42:39 -0400
Date: Thu, 18 Jun 2015 07:42:38 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: =?utf-8?B?7KGw7ISx7ZuI?= <ywhsbliss@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	johnny.kim@atmel.com, chris.park@atmel.com, Rachel.kim@atmel.com,
	dean.lee@atmel.com
Subject: Re: [PATCH 4/5] staging: wilc1000: remove prohibited spaces.
Message-ID: <20150618144238.GB8830@kroah.com> (sfid-20150618_164243_415062_D033E181)
References: <99c95a41549a43582fd1c679c34723d54771cbcc.1434519635.git.ywhsbliss@gmail.com>
 <0d07f1a77b401c709fb8ae4be248f5e27b20e688.1434519635.git.ywhsbliss@gmail.com>
 <20150618041802.GA10617@kroah.com>
 <CAAYiv+Yx-KzqE9UKeEO2NHJbzy8XL2z3YH5BbkXiBgXLHRhK7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAAYiv+Yx-KzqE9UKeEO2NHJbzy8XL2z3YH5BbkXiBgXLHRhK7Q@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 18, 2015 at 01:51:15PM +0900, 조성훈 wrote:
> Hi Greg,
> I want to make sure one thing before going further. I cloned the
> staging-testing and then made the first patch. There was no problem when I sent
> the first path to you.
> Afterwards, I also pulled the repository to update my local tree before making
> the second patch. So, I thought I made this second patch based on top of the
> latest commits.
> 
> I am confused why you said I need rebase. Do you mean I have to make my branch
> (for example, staging-wilc1000) from staging-testing and then rebase my commits
> to staging-testing branch before making patch files with git format-patch?

You made the patches correctly, I just accepted patches that were sent
before yours to the tree, which then conflicted with your patches.
That's what happens with a fast-moving tree and a driver that lots of
people are all trying to clean up at the same time.

So rebase on staging-testing again and resend and you should be fine.

thanks,

greg k-h
