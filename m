Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:36337 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757221AbXD0Ui5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Apr 2007 16:38:57 -0400
Message-ID: <46325F58.5070808@lwfinger.net>
Date: Fri, 27 Apr 2007 15:38:48 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Jiri Benc <jbenc@suse.cz>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: Wireless rates with mac80211
References: <462F9617.8010207@lwfinger.net>	<20070427221153.7ecc04de@griffin.suse.cz>	<46325B51.7090506@lwfinger.net> <20070427222932.548519eb@griffin.suse.cz>
In-Reply-To: <20070427222932.548519eb@griffin.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jiri Benc wrote:
> 
> Rate control modules can be switched on-the-fly with mac80211. You can
> write your own rc module that uses 1 mbps all times :-) Actually, I
> wrote that module but haven't kept it up to date so it doesn't even
> compile now...

No, the simple rate algorithm is fine. Once I make the connection, it is changing the rates up and 
down as I would have expected. The main problem was that I never got on, and without communication 
there was no basis on which to adjust the rate. Now it connects reliably, which makes it a lot 
easier to try fixes for the power problem. It is really hard to debug a power problem when nothing 
works.

Larry
