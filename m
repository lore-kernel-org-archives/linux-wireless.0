Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31301 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751925Ab1HPPhx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Aug 2011 11:37:53 -0400
Subject: Re: brcmsmac driver only works when sitting next to the AP
From: Dan Williams <dcbw@redhat.com>
To: Roland Vossen <rvossen@broadcom.com>
Cc: =?ISO-8859-1?Q?Camale=F3n?= <noelamac@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	Brett Rudley <brudley@broadcom.com>,
	Henry Ptasinski <henryp@broadcom.com>,
	Arend Van Spriel <arend@broadcom.com>,
	networkmanager-list@gnome.org
Date: Tue, 16 Aug 2011 10:40:10 -0500
In-Reply-To: <4E4A5641.4020604@broadcom.com>
References: <20110814121646.GA5188@stt008.linux.site>
	 <4E4A5641.4020604@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <1313509211.2065.36.camel@dcbw.foobar.com> (sfid-20110816_173756_412535_F516C336)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-08-16 at 13:36 +0200, Roland Vossen wrote:
> Hello Camaleón,
> 
> So the first problem that you encounter is that scan does not work. Lets 
> dive into that first.
> 
> I see in the log that you sent:
> 
> 'Aug 14 13:39:02 stt300 NetworkManager[1181]: 
> supplicant_interface_acquire: assertion `mgr_state == 
> NM_SUPPLICANT_MANAGER_STATE_IDLE' failed'
> 
> I also see many 'wpa_supplicant[1204]: Failed to initiate AP scan' messages.
> 
> There are no 'Failed to initiate AP scan' messages before the 'assertion 
> failed' message. I do not know if the 2nd message is a byproduct of the 
> 1st result. Regardless, a failed assertion is serious. I cc'ed the 
> network manager mailing list.

Yeah, the scanning issues are almost certainly what's causing stuff to
fail; which obviously seems like a driver issue at this point.

Dan

