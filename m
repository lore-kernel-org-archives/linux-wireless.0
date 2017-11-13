Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:53092 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751303AbdKMOg4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Nov 2017 09:36:56 -0500
Message-ID: <1510583813.30497.44.camel@sipsolutions.net> (sfid-20171113_153700_453896_229F9EE6)
Subject: Re: [PATCH v2 3/4] cfg80211: reg: remove support for built-in regdb
From: Johannes Berg <johannes@sipsolutions.net>
To: Benjamin Beichler <Benjamin.Beichler@uni-rostock.de>,
        Seth Forshee <seth.forshee@canonical.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 13 Nov 2017 15:36:53 +0100
In-Reply-To: <fffbdcf1-631e-d0de-836d-e95266afa686@uni-rostock.de>
References: <20171009095018.5289-1-johannes@sipsolutions.net>
         <20171009095018.5289-4-johannes@sipsolutions.net>
         <5392a1bb-378c-17c6-de0d-862e86041c2e@uni-rostock.de>
         <1510564989.30497.5.camel@sipsolutions.net>
         <20171113133609.yfysyojr2mwlahfl@ubuntu-hedt>
         <fffbdcf1-631e-d0de-836d-e95266afa686@uni-rostock.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2017-11-13 at 15:34 +0100, Benjamin Beichler wrote:
> Am 13.11.2017 um 14:36 schrieb Seth Forshee:
> > On Mon, Nov 13, 2017 at 10:23:09AM +0100, Johannes Berg wrote:
> > > On Mon, 2017-11-13 at 10:19 +0100, Benjamin Beichler wrote:
> > > > Is there already an example regulatory.db file available? 
> > > 
> > > There isn't yet, Seth?
> > 
> > Not yet. I've done some work on the patch you sent to make it generate
> > db files in both formats, not sure I'm ready to start actually releasing
> > files in the new format yet though. I suppose I could push it to a
> > testing branch with a signed regulatory.db file.
> 
> I would really appreciate this, since my current tool chain is not
> appropriate for this whole signing stuff and hwsim is failing to set my
> standard frequencies, because of the missing regdb.

You should be able to continue to use CRDA?

And if you don't, you can just disable signature checking and build the
binary yourself?

johannes
