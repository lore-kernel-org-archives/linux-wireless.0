Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:50985 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755143AbZCCVpP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Mar 2009 16:45:15 -0500
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net
Content-Type: text/plain; charset=iso-8859-1
Date: Tue, 03 Mar 2009 22:45:11 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
In-Reply-To: <b6c5339f0903021531g18e5b8f9lf8b352e182a4ce6d@mail.gmail.com>
Message-ID: <20090303214511.309210@gmx.net> (sfid-20090303_224521_052891_69C2CDFA)
MIME-Version: 1.0
References: <20090302222948.76770@gmx.net>	
 <b6c5339f0903021444m1f139f63p374cf41194ac2b62@mail.gmail.com>	
 <20090302230232.76770@gmx.net>
 <b6c5339f0903021531g18e5b8f9lf8b352e182a4ce6d@mail.gmail.com>
Subject: Re: [PATCH] ath5k: Set TSF fix
To: Bob Copeland <me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Bob!

> Yes, the compiler will optimize it out, but it looks noisy to me.  It=
's
> declared u64 one line above so it is clearly a no-op...  I guess it i=
s a
> personal taste thing.

Yes, in assembly I would agree. In higher languages I like to write mor=
e generally code.

> Ok, thanks!  I only mentioned it because I wanted to see the paramete=
rs
> and had to go back to the code.

ACK

Regards
Alina

--=20
Psssst! Schon vom neuen GMX MultiMessenger geh=F6rt? Der kann`s mit all=
en: http://www.gmx.net/de/go/multimessenger01
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
