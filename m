Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.183]:57093 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139AbYGAVOA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2008 17:14:00 -0400
Received: by py-out-1112.google.com with SMTP id p76so57158pyb.10
        for <linux-wireless@vger.kernel.org>; Tue, 01 Jul 2008 14:14:00 -0700 (PDT)
Subject: Re: Commit c4438fa71bf412862ed0b73111956b0ffd8209d3 breaks WPA
From: Harvey Harrison <harvey.harrison@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20080701203658.GA9225@tuxdriver.com>
References: <486A9248.9000607@lwfinger.net>
	 <20080701203658.GA9225@tuxdriver.com>
Content-Type: text/plain
Date: Tue, 01 Jul 2008 14:14:00 -0700
Message-Id: <1214946840.24353.3.camel@brick> (sfid-20080701_231407_082272_38ADCFCC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-07-01 at 16:36 -0400, John W. Linville wrote:
> On Tue, Jul 01, 2008 at 03:23:36PM -0500, Larry Finger wrote:
> > 7fa906d1d2acc6f9d88b923eed0990b9b14ea830 M      net
> >
> > This commit was confirmed as the problem by reverting it.
> 
> Luckily that is just in my "pending" stack.  I'll revert it ASAP.
> Harvey, you are welcome to resubmit if you can tell us what broke
> things! :-)
> 

Will investigate it this evening.

Harvey

