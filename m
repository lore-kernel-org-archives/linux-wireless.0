Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2713 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752770Ab3CXKKY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Mar 2013 06:10:24 -0400
Message-ID: <514ED101.9010006@broadcom.com> (sfid-20130324_111029_915695_6DE1A0E1)
Date: Sun, 24 Mar 2013 11:10:09 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Camale=F3n?= <noelamac@gmail.com>
cc: "Jonathan Nieder" <jrnieder@gmail.com>, 664767@bugs.debian.org,
	linux-wireless@vger.kernel.org
Subject: Re: Brcmsmac driver woes, possible regression?
References: <20130317144603.GA4850@stt008.linux.site>
 <1363532310.3937.266.camel@deadeye.wl.decadent.org.uk>
 <20130317152428.GA4940@stt008.linux.site>
 <20130317175658.GA8181@elie.Belkin>
 <20130317182725.GA5811@stt008.linux.site>
 <20130317183344.GA8786@elie.Belkin>
 <CAKprTDFhNnGOPHUqg8Wn6Cd170KaeXj7-w-D6wS2Cc38vstt5A@mail.gmail.com>
 <20130318083752.GA6570@elie.Belkin> <51476D25.6030609@broadcom.com>
 <20130318211428.GA9136@stt008.linux.site>
 <20130318212544.GB5062@elie.Belkin>
 <CAKprTDFXV4J7cxGqNck95Cu=ncBXCfdNTir40aWRtXjpLPO6OQ@mail.gmail.com>
 <CAKprTDEddPVp+bk7RJX1Jk60b0zVHr4ghvqt0HKnY+h238t3Zw@mail.gmail.com>
 <CAKprTDHHt76EYGKYH-FW6qPY6b=Cfe_Q_6HxxGOExbs=_TAkrQ@mail.gmail.com>
In-Reply-To: <CAKprTDHHt76EYGKYH-FW6qPY6b=Cfe_Q_6HxxGOExbs=_TAkrQ@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/23/2013 04:28 PM, Camaleón wrote:
> 2013/3/19 Camaleón <noelamac@gmail.com>:
> 
>>> Now let's see how reverting the patch makes any difference as soon as
>>> I can compile the module. I will keep you updated
>>
>> Update: applied the patch to revert the "other" patch but I still
>> cannot get the driver to work (see attached syslog). N-M still asks
>> for password until desists :-(
> 
> More verbose logs, just in case someone finds something of interest.
> 
> Greetings,
> 

What I see in this log is that your AP keeps sending EAPOL message 1 and
you keep sending EAPOL message 2 until one gives up the attempts. This
behaviour would suggest the psk is wrong as indicated in the log, but
you said you could connect using another card, right? So using the same
configured N-M connection?

Regards,
Arend


