Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.230]:54572 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754619AbXJJT22 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2007 15:28:28 -0400
Received: by nz-out-0506.google.com with SMTP id s18so243850nze
        for <linux-wireless@vger.kernel.org>; Wed, 10 Oct 2007 12:28:27 -0700 (PDT)
Message-ID: <1ba2fa240710101228vef839abj1aeab0fabf60e449@mail.gmail.com> (sfid-20071010_202833_975056_6B378502)
Date: Wed, 10 Oct 2007 21:28:25 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ipw3945-devel] mac80211/iwlwifi + hidden ssids
Cc: "Ferguson, Dana R" <dana.r.ferguson@intel.com>,
	"Dan Williams" <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <20071010181019.GJ5962@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <4616099B20F1F24C8ADC5B1BFE2A0F88037D3D8B@fmsmsx413.amr.corp.intel.com>
	 <4616099B20F1F24C8ADC5B1BFE2A0F88037D3DBF@fmsmsx413.amr.corp.intel.com>
	 <20071010181019.GJ5962@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

1. Blan SSID scanning is not CCX feature. It should work just need to
be properly configured.
2. Scanning in iwl driver is always initiated by the driver unlike ipw2X.
3. CCX is closed standard by Cisco and we are not eligible to open it.
Talk to Cisco

Tomas

On 10/10/07, John W. Linville <linville@tuxdriver.com> wrote:
> On Wed, Oct 10, 2007 at 10:54:46AM -0700, Ferguson, Dana R wrote:
> > Hey,
> >
> > I bit more info. I am hearing it is a Cisco CCX feature and will not be
> > included in the open source code.
> >
> > Dana
>
> Huh?  I'm not sure what "it" is?  Care to elaborate?
>
> I do find it dismaying to hear that Intel is holding back wireless
> compatibility features from Linux...
>
> John
> --
> John W. Linville
> linville@tuxdriver.com
>
> -------------------------------------------------------------------------
> This SF.net email is sponsored by: Splunk Inc.
> Still grepping through log files to find problems?  Stop.
> Now Search log events and configuration files using AJAX and a browser.
> Download your FREE copy of Splunk now >> http://get.splunk.com/
> _______________________________________________
> Ipw3945-devel mailing list
> Ipw3945-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/ipw3945-devel
>
