Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:52445 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614AbZFATaT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2009 15:30:19 -0400
Received: by fg-out-1718.google.com with SMTP id d23so646664fga.17
        for <linux-wireless@vger.kernel.org>; Mon, 01 Jun 2009 12:30:19 -0700 (PDT)
Message-ID: <4A242C47.1080405@gmail.com>
Date: Mon, 01 Jun 2009 21:30:15 +0200
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Gaurav.Jauhar@atheros.com, senthilkumar@atheros.com,
	ath9k-devel@lists.ath9k.org, leann.ogasawara@canonical.com,
	tim.gardner@canonical.com, parag.warudkar@gmail.com,
	drago01@gmail.com, drjoms@gmail.com, debaditya@gmail.com,
	arxs@fedoraproject.org, michal@harddata.com, fabian.deutsch@gmx.de
Subject: Re: Pending ath9k bugs
References: <20090601184134.GC5516@tesla>
In-Reply-To: <20090601184134.GC5516@tesla>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/01/2009 08:41 PM, Luis R. Rodriguez wrote:
> Red Hat Bugzilla:
...
> 4) "NetworkManager requires ath9k reload to work. [NEEDINFO]"
> 	https://bugzilla.redhat.com/show_bug.cgi?id=489216
> 
> OpenSuse:
> 
> 1) "wi-fi card Atheros AR928X returns "no scan results""
> 	https://bugzilla.novell.com/show_bug.cgi?id=462673
> 	Not sure what to make of this. Jiri might know better.

As far as I can tell, it's unrelated to the kernel. It's NM or a user
setting what is to blame here. And maybe it's related to the RH entry above?

