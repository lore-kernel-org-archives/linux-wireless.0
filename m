Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:50757 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754895AbZAIUBS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2009 15:01:18 -0500
Message-ID: <4967AD07.3050504@lwfinger.net> (sfid-20090109_210122_887559_6719023C)
Date: Fri, 09 Jan 2009 14:01:11 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: feldmaus <feldmann_markus@gmx.de>
CC: Matthew Garrett <mjg59@srcf.ucam.org>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: show WMI magic Signals and activate hardware RF-kill button
References: <gk83fe$fu2$1@ger.gmane.org> <49679783.8070901@lwfinger.net> <gk89qs$mra$1@ger.gmane.org>
In-Reply-To: <gk89qs$mra$1@ger.gmane.org>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

feldmaus wrote:
> Larry Finger schrieb:
>>
>> There is a protocol named WMI for Windows Management Interface. I
>> assume that it was invented by the folks in Redmond. In any case, it
>> is designed to handle events that have buttons that do not generate a
>> keycode. The module named hp-wmi is supposed to take care of the
>> things under Linux for HP and Compaq computers.
>>
>> Did you generate this module? Is it loaded?
> By now, yes.
> hp_wmi                  4632  0
> rfkill                  9648  4 rfkill_input,hp_wmi,b43legacy
> wmi                     6568  1 hp_wmi
> 
> But i still do not get any keycode with <showkey>.
> Is there an other program than <showkey> ?
> 
> Where i can solve this problem with the wmi code ?

It will never generate a keycode. It uses some other means, which is
why I called it magic.

The module author is Matthew Garrett <mjg59@srcf.ucam.org>, whom I
have cc'd.

Larry
