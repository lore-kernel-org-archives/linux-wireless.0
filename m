Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39342 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757535Ab2CEUCG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Mar 2012 15:02:06 -0500
Date: Mon, 5 Mar 2012 14:59:27 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: David Miller <davem@davemloft.net>, linux-wireless@vger.kernel.org,
	johannes.berg@intel.com
Subject: Re: [PATCH 001/101] iwlwifi: move iwl_clear_driver_stations to user
Message-ID: <20120305195927.GG18128@tuxdriver.com> (sfid-20120305_210213_734433_F054CC64)
References: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
 <1330889395-533-2-git-send-email-wey-yi.w.guy@intel.com>
 <20120304.203259.81092010167419901.davem@davemloft.net>
 <1330907855.12612.50.camel@wwguy-huron>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1330907855.12612.50.camel@wwguy-huron>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Mar 04, 2012 at 04:37:35PM -0800, Guy, Wey-Yi wrote:
> On Sun, 2012-03-04 at 20:32 -0500, David Miller wrote:
> > You seriously cannot queue up this work all at one time.
> > 
> > It is absolutely unreasonable to burdon the community with having to
> > review a hundred patches at one time.
> > 
> > You must split these submissions down into smaller groups, say groups
> > of 10 or so patches.
> > 
> > Also consider what if one patch in the first ten has a problem, and
> > this causes conflicts with the next 90 patches?
> 
> I understand there are a lot of patches, we are doing major re-factor
> works and those patches are inter-related. I could try to see if I can
> break those into smaller groups (maybe 20 - 30 patches a group).
> 
> John/David, are you prefer to see the submission like this?

This is a large request.  But FWIW, the iwlwifi team typically does
manage their own trees and works via pull requests.

It might be nice to see more/smaller requests in the future.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
