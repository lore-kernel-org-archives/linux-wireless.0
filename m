Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49826 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311Ab0CFP4t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Mar 2010 10:56:49 -0500
Date: Sat, 6 Mar 2010 10:54:51 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: Sujith <Sujith.Manoharan@atheros.com>,
	Pavel Roskin <proski@gnu.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	Senthilkumar Balasubramanian
	<Senthilkumar.Balasubramanian@Atheros.com>
Subject: Re: [PATCH] ath9k_htc: Add ath9k_htc driver
Message-ID: <20100306155451.GA3595@tuxdriver.com>
References: <19335.43241.887933.207404@gargle.gargle.HOWL>
 <1267209201.30426.8.camel@mj>
 <43e72e891002261042s587f9fb8g9f491b1bac363582@mail.gmail.com>
 <1267233595.2835.20.camel@mj>
 <19336.44484.226966.463482@gargle.gargle.HOWL>
 <87hboteaia.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <87hboteaia.fsf@purkki.valot.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Mar 06, 2010 at 05:27:09PM +0200, Kalle Valo wrote:
> Sujith <Sujith.Manoharan@atheros.com> writes:
> 
> >> The original patch should be run through checkpatch.pl.  In addition to
> >> overly long lines, there are some other formatting issues.
> >
> > I thought that the default was 106 (or 132 ?) these days ..
> 
> From CodingStyle:
> 
> "The limit on the length of lines is 80 columns and this is a strongly
> preferred limit."
> 
> And I fully agree with that. It's easier to read code that way.

ACK

-- 
John W. Linville                Someday the world will need a hero, and you
linville@tuxdriver.com                  might be all we have.  Be ready.
