Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:33349 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756397AbXEJRps (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2007 13:45:48 -0400
Message-ID: <46435A4B.3030502@lwfinger.net>
Date: Thu, 10 May 2007 12:45:47 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Wu <flamingice@sourmilk.net>
CC: Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH V3] mac80211: Add support for SIOCGIWRATE ioctl to provide  rate information
References: <463a8a92.jFmmjY4cDnfJeisJ%Larry.Finger@lwfinger.net> <200705101156.12588.flamingice@sourmilk.net> <46434AB4.1070807@lwfinger.net> <200705101333.03257.flamingice@sourmilk.net>
In-Reply-To: <200705101333.03257.flamingice@sourmilk.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Wu wrote:
> 
> But there's more interesting things to do, like implementing siwrate so we can 
> get rid of the corresponding prism2 ioctl.

I'll take a stab at siwrate. It will be more interesting than what I'm doing now.

Larry
