Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:50039 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179AbbJGRs4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Oct 2015 13:48:56 -0400
Date: Wed, 7 Oct 2015 13:48:55 -0400
From: Kyle McMartin <kyle@infradead.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: Kyle McMartin <kyle@infradead.org>, linux-wireless@vger.kernel.org,
	Rafal Milecki <zajec5@gmail.com>
Subject: Re: [PATCH] brcmfmac: firmware refresh for BCM43602 PCIE devices
Message-ID: <20151007174855.GI26918@merlin.infradead.org> (sfid-20151007_194859_618328_07743A97)
References: <1443120304-11153-1-git-send-email-arend@broadcom.com>
 <20150925000004.GF26918@merlin.infradead.org>
 <560C139B.7040604@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <560C139B.7040604@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 30, 2015 at 06:53:47PM +0200, Arend van Spriel wrote:
> On 09/25/2015 02:00 AM, Kyle McMartin wrote:
> >On Thu, Sep 24, 2015 at 08:45:04PM +0200, Arend van Spriel wrote:
> >>A number of end-users reported issues with BCM43602 on the 2015
> >>MacBook Pro. It turned out the previously released firmware did
> >>not properly support that device [1]. Hence an update of the STA
> >>firmware and while at it refresh the AP firmware as well. The
> >>latter has been tested using Netgear R8000. The STA firmware has
> >>been tested on MacBook Pro.
> >>
> >
> >Are there version numbers we could update in WHENCE to make this
> >easier to track?
> 
> Hi Kyle,
> 
> For brcmfmac firmware we do not have version numbers in the WHENCE file. The
> firmware file itself contains the version number which can be shown using
> hexdump. I can make a note of that fact in the WHENCE file if needed.
> 

Sorry, I meant to apply this a few days ago, but I finally pushed it
out. Thanks for your patience.

regards, --Kyle
