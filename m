Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:54027 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752582AbYJFFmU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2008 01:42:20 -0400
Subject: Re: at76_usb driver status
From: Pavel Roskin <proski@gnu.org>
To: Kalle Valo <Kalle.Valo@iki.fi>
Cc: Greg KH <greg@kroah.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <87vdw6mgdl.fsf@litku.valot.fi>
References: <20081002210742.GA27221@kroah.com> <87y713y48r.fsf@nokia.com>
	 <20081005061603.GB28533@kroah.com> <87d4ifsgg5.fsf@litku.valot.fi>
	 <1223270894.18180.7.camel@dv>  <87vdw6mgdl.fsf@litku.valot.fi>
Content-Type: text/plain
Date: Mon, 06 Oct 2008 01:42:17 -0400
Message-Id: <1223271737.18180.15.camel@dv> (sfid-20081006_074222_260683_BEF8A4E4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-10-06 at 08:39 +0300, Kalle Valo wrote:
> Pavel Roskin <proski@gnu.org> writes:
> 
> > I'm not going to scream, and I'm not sure my opinion really matters, but
> > I don't think it's a good idea to have two different drivers under the
> > same name in different kernel trees.
> >
> > My preference is that we give a better exposure to the mac80211 based
> > driver, so that potential contributors don't spend time on dead end
> > code.
> 
> I agree, it's very confusing. I'll change the name of the mac80211
> port to something else, most probably to at76c50x-usb. Any comments?
> Anyone?

I'd rather avoid the old driver completely.  But if we want to resurrect
it, its name was "at76c503a".

-- 
Regards,
Pavel Roskin
