Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:33787 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674AbcCYQLe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Mar 2016 12:11:34 -0400
Received: by mail-oi0-f47.google.com with SMTP id d205so101628098oia.0
        for <linux-wireless@vger.kernel.org>; Fri, 25 Mar 2016 09:11:34 -0700 (PDT)
Date: Fri, 25 Mar 2016 11:11:00 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Thanh_Nguyen@Dell.com
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: wireless-regdb: Update regulatory rules for Russia (RU) on
 5735-5835 MHz band
Message-ID: <20160325161100.GA112464@ubuntu-hedt> (sfid-20160325_171137_519205_5E101B5F)
References: <b7a3a22077814e7da4e94a61e59c585d@ausx13mpc122.AMER.DELL.COM>
 <20160325135147.GA27324@ubuntu-xps13>
 <215edc732bbb4c8aa7b38dd1273f372a@ausx13mpc122.AMER.DELL.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <215edc732bbb4c8aa7b38dd1273f372a@ausx13mpc122.AMER.DELL.COM>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 25, 2016 at 03:59:30PM +0000, Thanh_Nguyen@Dell.com wrote:
> Seth,
> The sources I am using are also unofficial:
> 
> o   Broadcom’s document showing Russia allow 2.400-2.4835 (Ch 1-13), 5.15-5.25GHz (Ch 36-48), 5.25-5.35GHz (Ch 52-64), 5.470-5.725GHz (Ch 100-140)
> 
> o   Wi-Fi Russian Certificates that Broadcom and Intel (and some other major suppliers) provided to Dell don’t cover 5735-5835 MHz band
> I will try to obtain official documentation of Russia's regulations.

Thanks, that would be helpful. All I could turn up was a document
regarding fixed wireless installations, in which the 5375-5835 MHz range
was allowed.

> Regarding the Patch, I am new to Linux and I am not sure what that is. It will be great if you can make one or guide me how to do it.

Let's hold off a bit. That will give you some time to look for some
official sources, and I'd also like to leave a little time to see if QCA
has any comments since the rules we currently have for Russia came from
them.

Seth
