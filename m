Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:40036 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751915Ab3HFNlm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Aug 2013 09:41:42 -0400
Date: Tue, 6 Aug 2013 21:42:18 +0800
From: Greg KH <greg@kroah.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	stable@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3.10 0/3] Enable 7000 device family on 3.10
Message-ID: <20130806134218.GB525@kroah.com> (sfid-20130806_154146_011783_B3A8D496)
References: <1373888700-3040-1-git-send-email-emmanuel.grumbach@intel.com>
 <20130802090234.GA20470@kroah.com>
 <1375792779.8219.16.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1375792779.8219.16.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 06, 2013 at 02:39:39PM +0200, Johannes Berg wrote:
> [Emmanuel is on vacation, I'll cover for him]
> 
> On Fri, 2013-08-02 at 17:02 +0800, Greg KH wrote:
> > On Mon, Jul 15, 2013 at 02:44:57PM +0300, Emmanuel Grumbach wrote:
> > > This small patch series enables 7260 and 3160 devices on 3.10
> > > kernel. Three patches are already in linux.git (3.11-rc1).
> > > One patch is 3.10 specific and disables configuration that is not
> > > supported in 3.10.
> > 
> > I need the git commit id of these patches in Linus's tree before I can
> > apply them.  Please resend them with that information.
> 
> The second and third patch does have it, and the first patch is only
> relevant for 3.10 since 3.11 will have more device types enabled, we
> just didn't get all the code in. This seems to be described in the
> commit log, do you want more details?

Yes, please resend them with those details.  For me to take a patch that
is not in Linus's tree is a big deal, I need a whole lot of
justification for it.

greg k-h
