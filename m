Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f179.google.com ([209.85.223.179]:62128 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932786Ab3CVLhC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Mar 2013 07:37:02 -0400
Received: by mail-ie0-f179.google.com with SMTP id k11so4658634iea.10
        for <linux-wireless@vger.kernel.org>; Fri, 22 Mar 2013 04:37:01 -0700 (PDT)
Date: Fri, 22 Mar 2013 07:37:17 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: thomas@cozybit.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: return new mpath from mesh_path_add()
Message-ID: <20130322113716.GC2808@localhost> (sfid-20130322_123707_131039_8D62924D)
References: <20130321022033.GA17491@localhost>
 <1363949056.8238.12.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1363949056.8238.12.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 22, 2013 at 11:44:16AM +0100, Johannes Berg wrote:
> On Wed, 2013-03-20 at 22:20 -0400, Bob Copeland wrote:
> > Most times that mesh_path_add() is called, it is followed by
> > a lookup to get the just-added mpath.  We can instead just
> > return the new mpath in the case that we allocated one (or the
> > existing one if already there), so do that.  Also, reorder the
> > code in mesh_path_add a bit so that we don't need to allocate
> > in the pre-existing case.
> 
> This doesn't apply (on mac80211-next.)

Sorry, thought I rebased there, but I'll give it a respin.

-- 
Bob Copeland %% www.bobcopeland.com
