Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:37265 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751545AbXEYNf0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 May 2007 09:35:26 -0400
Message-ID: <4656E61B.8020505@warmcat.com>
Date: Fri, 25 May 2007 14:35:23 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: Linux Magazin article on mac80211
References: <4655A7C2.6030600@warmcat.com>	 <1180087351.3604.8.camel@johannes.berg>  <4656B8C5.4010409@warmcat.com> <1180098098.3604.46.camel@johannes.berg>
In-Reply-To: <1180098098.3604.46.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Fri, 2007-05-25 at 11:21 +0100, Andy Green wrote:
> 
>> Thanks I appreciate the mention :-))   I will freshen the injection
>> patch in the next few days and propose it once more. 
> 
> :)
> I had been doing similar things last year btw, but not for file transfer
> but peer to peer location services. It might be very interesting to
> split up penumbra into one daemon for communication and one for the
> actual usage of that communication. Then, the communication daemon could
> be very small code and even be setuid, or possibly use dbus. Thoughts?

I have been having similar thoughts, that I currently integrated too
much vertical stuff into one monolithic thing that is more specific than
it has to be.  For example, shouldn't it somehow be possible to tunnel
TCP/IP anonymously over this unencrypted transport?  Maybe people
offering to bridge only want to whitelist news.bbc.co.uk, but still.
Shouldn't it offer an effective distributed NNTP proxy (again you might
only feel only able to offer a newsgroup whitelist as the bridge)?
Someone else suggested, shouldn't it bridge to Gnutella?  Not sure I am
brave enough to run an Internet bridge like that, but enough anonymous
users and it can run Gnutella protocol just between the users without a
bridge to the wired Internet.

Maybe the answer is to offer a netdev interface from a penumbra module
again.  For example if you send a TCP packet down it, it goes out with a
onetime magic cookie prepended that is required in any answer...

>>  I also adapted
>> aircrack to work with the mac80211 monitor mode injection in the meanwhile.
> 
> Cool.

I guess it is better that I am running aircrack against my network
before anyone else does.  (Although all they will find is set of ssh
tunnels if they beat WPA here).

-Andy
