Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.232]:27947 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125AbXHBNL1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2007 09:11:27 -0400
Received: by wr-out-0506.google.com with SMTP id 36so170407wra
        for <linux-wireless@vger.kernel.org>; Thu, 02 Aug 2007 06:11:27 -0700 (PDT)
Message-ID: <1ba2fa240708020611k2244f23cofc12fc1a4ddcf3aa@mail.gmail.com>
Date: Thu, 2 Aug 2007 16:11:27 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [ipw3945-devel] chaning mode only when interface down?
Cc: "Dan Williams" <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	"network manager" <networkmanager-list@gnome.org>,
	ipw3945-devel@lists.sourceforge.net
In-Reply-To: <1186058803.24230.42.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <C07C4589BE74A34981C3C3525EE1F801024CF30B@hasmsx412.ger.corp.intel.com>
	 <1186058803.24230.42.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8/2/07, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2007-08-02 at 15:41 +0300, Winkler, Tomas wrote:
>
> > I'm really not an expert on the configuration but I think at least the
> > transition from STA to IBSS mode and back should be smooth without
> > reloading the driver. What you do if the driver is compiled to kernel
> > will we reboot?
>
> Oh you don't have to reload the driver, you only have to down the
> interface.
I suspected we are not talking about the same :)

If you have to reload it that's a driver bug, but the fact
> that you have to down the interface is a mac80211 "limitation"
>
Yes it is
> johannes
>
> -------------------------------------------------------------------------
> This SF.net email is sponsored by: Splunk Inc.
> Still grepping through log files to find problems?  Stop.
> Now Search log events and configuration files using AJAX and a browser.
> Download your FREE copy of Splunk now >>  http://get.splunk.com/
> _______________________________________________
> Ipw3945-devel mailing list
> Ipw3945-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/ipw3945-devel
>
>
>
