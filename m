Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from will39.synserver.de ([212.40.172.10]:43659 "EHLO willies.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755823AbZGGNp0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jul 2009 09:45:26 -0400
Message-ID: <4A535168.4050800@willies.info>
Date: Tue, 07 Jul 2009 15:45:12 +0200
From: Jan Willies <jan@willies.info>
MIME-Version: 1.0
To: Dan Williams <dcbw@redhat.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: 4965AGN loses connection on Custom wireless event
References: <4A4B5EC8.8060804@willies.info> <1246458585.12198.114.camel@localhost.localdomain>
In-Reply-To: <1246458585.12198.114.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 01.07.2009 16:29, Dan Williams wrote:
> Jouni, how should the supplicant handle a WEXT assoc event for the AP
> that's already associated with?  That seems to be what's going on here;
> the card is coming back from a scan and emitting an assoc event (not
> sure why) and that's making the supplicant (wrongly IMHO) try to reauth
> at the EAP level for some reason.

Did I miss the answer here? Is there any more information I can provide?


  - jan
