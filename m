Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:58024 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936AbbASSmq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2015 13:42:46 -0500
Received: by mail-wi0-f170.google.com with SMTP id em10so22961wid.1
        for <linux-wireless@vger.kernel.org>; Mon, 19 Jan 2015 10:42:45 -0800 (PST)
Date: Mon, 19 Jan 2015 20:32:09 +0200
From: Vadim Kochan <vadim4j@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Vadim Kochan <vadim4j@gmail.com>,
	Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH] Revert "wireless: Support of IFLA_INFO_KIND rtnl
 attribute"
Message-ID: <20150119183209.GA27580@angus-think.lan> (sfid-20150119_194250_012326_FA6F177D)
References: <1421689943-13264-1-git-send-email-johannes@sipsolutions.net>
 <1421690572.1965.41.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1421690572.1965.41.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 19, 2015 at 07:02:52PM +0100, Johannes Berg wrote:
> On Mon, 2015-01-19 at 18:52 +0100, Johannes Berg wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> > 
> > This reverts commit ba1debdfed974f25aa598c283567878657b292ee.
> > 
> > Oliver reported that it breaks network-manager, for some reason with
> > this patch NM decides that the device isn't wireless but "generic"
> > (ethernet), sees no carrier (as expected with wifi) and fails to do
> > anything else with it.
> > 
> > Revert this to unbreak userspace.
> 
> git-email didn't Cc Vadim or Marcel ...
> 
> Looks like we can't do this since it will break userspace - please don't
> write any tools depending on it :)
> 
> johannes
> 
I am really surprised, will dig into NM ...
