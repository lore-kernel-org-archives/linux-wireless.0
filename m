Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:65061 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752160AbYLZBUH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Dec 2008 20:20:07 -0500
Subject: Re: 4965AGN Not Associating
From: Pavel Roskin <proski@gnu.org>
To: Delphi Real Estate <Info@delphi-real-estate.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <200812250800.26394.Info@delphi-real-estate.com>
References: <200812241158.29493.Info@delphi-real-estate.com>
	 <1230166611.2688.3.camel@debian.sh.intel.com>
	 <200812250800.26394.Info@delphi-real-estate.com>
Content-Type: text/plain
Date: Thu, 25 Dec 2008 20:20:05 -0500
Message-Id: <1230254405.17014.26.camel@dv> (sfid-20081226_022013_748663_3EB50FD3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-12-25 at 08:00 -0800, Delphi Real Estate wrote:

> All right, so the kernel iwl modules are working with this kernel,
> good enough for me... although iwconfig shows, "Encryption
> key:AM32-52G0-50D6-130B-6AF0-201D-9450-H978 [2]   Security
> mode:open".  
> 
> 'Open'?  Homey don't think so.  The AP us set to WPA AES.  Why would
> it say it's open?

It means "open system authentication", as opposed to "shared key"
authentication, which can only be used with WEP.

If iwconfig was smarter, it would show "WPA" there, but it's not so
smart.

-- 
Regards,
Pavel Roskin
