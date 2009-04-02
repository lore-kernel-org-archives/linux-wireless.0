Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost04.isp.att.net ([204.127.217.104]:47231 "EHLO
	fmailhost04.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765704AbZDBSmy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Apr 2009 14:42:54 -0400
Message-ID: <49D506FE.5070405@lwfinger.net> (sfid-20090402_204312_130369_AE50829A)
Date: Thu, 02 Apr 2009 13:42:06 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: How does rfkill work?
References: <49D44635.80306@lwfinger.net>	 <1238666206.4141.12.camel@johannes.local>  <49D4CF50.2060100@lwfinger.net>	 <1238684527.4141.63.camel@johannes.local>  <49D4D833.9070107@lwfinger.net>	 <1238689637.24708.41.camel@johannes.local>  <49D5018E.6050001@lwfinger.net> <1238696967.6137.5.camel@johannes.local>
In-Reply-To: <1238696967.6137.5.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> 
> Also, if increasing that helps, does it also work then? I mean, does the
> LED get turned on/off?

No. I'm still not getting the appropriate call to the set brightness callback.
Actually, I didn't expect any change as the truncation from the too-short array
length only occurs when the pseudo file is dumped.

Larry
