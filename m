Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0006.hostedemail.com ([216.40.44.6]:34952 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751394AbcDRP4p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2016 11:56:45 -0400
Message-ID: <1460995000.1917.5.camel@perches.com> (sfid-20160418_175650_856004_06E0B8B8)
Subject: Re: [PATCH 00/16] rtl8xxxu prepare for splitting into multiple files
From: Joe Perches <joe@perches.com>
To: Jes.Sorensen@redhat.com, linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net
Date: Mon, 18 Apr 2016 08:56:40 -0700
In-Reply-To: <1460994576-24091-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1460994576-24091-1-git-send-email-Jes.Sorensen@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-04-18 at 11:49 -0400, Jes.Sorensen@redhat.com wrote:
> From: Jes Sorensen <Jes.Sorensen@redhat.com>
> 
> Hi,
> 
> This is the last set of patches I have in my queue for the rtl8xxxu
> driver, as of today :)
> 
> Since the driver has grown to support quite a number of different
> chips, I want to split it into multiple files. This will make it
> easier to maintain and also eaiser to add support for more chips
> without having to constantly touch the core files.
> 
> This set renames a bunch of functions to indicate that they are
> generic rather than chip specific. I will look at doing the actual
> moving around in a set right after the current merge window closes.

It's a bit of a pity that the identifiers are all
quite long.  Using these long identifiers makes
80 column content a bit right shifted and single
line statements unlikely.

