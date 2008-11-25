Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from n6.bullet.mud.yahoo.com ([216.252.100.57]:35629 "HELO
	n6.bullet.mud.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752254AbYKYRbG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2008 12:31:06 -0500
Date: Tue, 25 Nov 2008 09:24:31 -0800 (PST)
From: Irwan Siajadi <dev.bahamot@yahoo.com>
Subject: Re: ath5k: can't browse at all.
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1227552792.26229.6.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <790145.29340.qm@web59606.mail.ac4.yahoo.com> (sfid-20081125_183111_963338_28195A93)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Further testing shows that if I change from WPA2/AES to WPA/TIKIP, I can finally browse. But it's still hit and missed, I need to reload the pages once or twice before the pages can load properly. 

Thanks for the reply.

--- On Mon, 11/24/08, Pavel Roskin <proski@gnu.org> wrote:

> From: Pavel Roskin <proski@gnu.org>
> Subject: Re: ath5k: can't browse at all.
> To: "Irwan Siajadi" <dev.bahamot@yahoo.com>
> Cc: linux-wireless@vger.kernel.org
> Date: Monday, November 24, 2008, 6:53 PM
> On Mon, 2008-11-24 at 09:41 -0800, Irwan Siajadi wrote:
> > The AR2425 is able to obtain IP address from the
> router, 
> > able to ping with good results, but can't browse
> at all.
> > Below are the info on my setup, if you need more info
> please let me know.
> 
> That's unlikely to be a driver problem.  The driver
> doesn't distinguish
> pings from other packets.  The only significant difference
> could be in
> the packet size.  You can try ping with larger packets to
> check if
> that's the problem.
> 
> I suggest that you use normal network troubleshooting
> procedures and not
> assume the driver to be a problem unless you have a better
> evidence.
> Check routing, check if the nameservers in /etc/resolv.conf
> are working.
> I'm sure there are detailed guides how to troubleshoot
> networks.
> 
> -- 
> Regards,
> Pavel Roskin


      

