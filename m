Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from postler.einfach.org ([86.59.21.14]:55236 "EHLO home.einfach.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755951Ab0LJMxu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Dec 2010 07:53:50 -0500
From: Bruno Randolf <br1@einfach.org>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH v2] cfg80211: Add antenna availability information
Date: Fri, 10 Dec 2010 21:47:20 +0900
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
References: <20101208034429.24218.50707.stgit@localhost6.localdomain6> <20101208143101.GC2423@tuxdriver.com>
In-Reply-To: <20101208143101.GC2423@tuxdriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201012102147.20209.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 08 December 2010 23:31:01 John W. Linville wrote:
> On Wed, Dec 08, 2010 at 12:44:29PM +0900, Bruno Randolf wrote:
> > Add a field to wiphy for the hardware to report the availble antennas for
> > configuration. Only if this is set to something bigger than zero, will
> > the anntenna configuration ops be executed.
> > 
> > Allthough this could be a simple number of antennas, I defined it as a
> > bitmap of antennas which are available for configuration, since it's
> > more consistent with the rest of the antenna API and there could be
> > cases where the hardware allows only configuration of certain antennas.
> > As it does not make much of a difference in size or normal usage, I
> > think it's better to be able to support this, in case the need arises.
> > 
> > The antenna configuration is now also checked against the availabe
> > antennas and rejected if it does not match.
> > 
> > Signed-off-by: Bruno Randolf <br1@einfach.org>
> > 
> > v2:	reject antenna configurations which don't match the available
> > antennas ---
> 
> Please either put the "v2" part before the "Signed-off-by" or
> (preferably) after the "---" line.  Also, make sure to use 3 "-"
> characters -- often you use only 2 of them and the results from
> applying with "git am" are messy.

Oh, I'm sorry for that. For some reason I thought 2 -- are ok. Will be careful 
to have three from now on.

bruno
