Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail5.dslextreme.com ([66.51.199.81]:34879 "HELO
	mail5.dslextreme.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753236AbYJTUFH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2008 16:05:07 -0400
Subject: Re: Marvell TopDog Driver Work
From: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
To: linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890810201245t3ac18fd6taf229af88350958f@mail.gmail.com>
References: <48A5DBAB.9080405@erley.org> <20080815195825.GD5935@tesla>
	 <1218830917.14841.20.camel@localhost.localdomain>
	 <gdidhg$hdq$3@ger.gmane.org>
	 <1224524168.29822.46.camel@dhcp-100-3-195.bos.redhat.com>
	 <1224525810.6873.8.camel@the-omnibook>
	 <43e72e890810201245t3ac18fd6taf229af88350958f@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 20 Oct 2008 13:05:05 -0700
Message-Id: <1224533105.6873.22.camel@the-omnibook> (sfid-20081020_220513_472497_5A91103E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-10-20 at 12:45 -0700, Luis R. Rodriguez wrote:
> On Mon, Oct 20, 2008 at 11:03 AM, Daniel Gimpelevich
> <daniel@gimpelevich.san-francisco.ca.us> wrote:
> 
> > The "Duh..." was a response to the "Not that I have heard of. Don't
> > know." statement, which was pretty ironic.
> 
> Well your question was "Has anyone stepped up to help in the port of
> this to mac80211" and I thought you already knew I had that tree.

I did not ask that, because I saw the tree, and that the initial import
was from the marvell.git tree. The OP might not have realized that the
code was TopDog-related even if he did see it. Since there is no working
mac80211 code for TopDog, any existing hardware-specific code for it may
prove to be a useful reference during the porting process. Anybody
investigating the possibility of stepping up to help in the port needs
to know what is already available and what is not.

I don't think there is any question of *whether* TopDog support is
possible in mrv8k, only when, and "right now" does not yet appear to be
the answer. I really hope to be proven wrong on that, though.

