Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server4.hostdango.com ([70.86.37.74]:45045 "EHLO
	server4.hostdango.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932Ab0KNCg5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Nov 2010 21:36:57 -0500
Message-ID: <4CDF4B47.2000207@krellan.com>
Date: Sat, 13 Nov 2010 18:36:55 -0800
From: Josh Lehan <krellan@krellan.com>
MIME-Version: 1.0
To: Paul Stewart <pstew@google.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Distinguishing wrong password from other failure to connect?
References: <4CDCEBE9.8060905@krellan.com> <AANLkTikHOsYPwU0J-bYFGQamCS4CVUP5T_B1yGLCjmD5@mail.gmail.com>
In-Reply-To: <AANLkTikHOsYPwU0J-bYFGQamCS4CVUP5T_B1yGLCjmD5@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/12/2010 09:21 AM, Paul Stewart wrote:
> The "reason=xx" codes are standardized by 802.11.  However when
> reading such messages, one needs to be careful to note which party
> sent that reason code.  There are times when the AP sends this
> message, and other times where the station sends it as it departs.

Thanks for the information.  Is there a guideline as to what messages
indicate wrong settings by the user (wrong password, etc.)?

Basically, I'm trying to know where to pin the blame: on the user's
wrong password, or on the network itself.

Josh
