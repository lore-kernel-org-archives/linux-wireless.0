Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31149 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752238Ab3JUFqy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Oct 2013 01:46:54 -0400
Date: Mon, 21 Oct 2013 07:43:21 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Daniel Wrede <dawre12@student.sdu.dk>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: regarding Linux Wifi driver
Message-ID: <20131021054320.GA1443@redhat.com> (sfid-20131021_074711_485230_6635063A)
References: <6F561AC697923E43A7559754DA2EE97C3201BFF0@ADM-EXMBX10D.adm.c.sdu.dk>
 <CACna6rzC_jOeE1=r85EJg=jdrr-gbmKCJ1fFwUwySczRsZskSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CACna6rzC_jOeE1=r85EJg=jdrr-gbmKCJ1fFwUwySczRsZskSQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 18, 2013 at 02:49:15PM +0200, Rafał Miłecki wrote:
> 2013/10/18 Daniel Wrede <dawre12@student.sdu.dk>:
> > I do have a question regarding the drivers on http://wireless.kernel.org/en/users/Drivers/iwlegacy
> 
> You're writing to generic Linux wireless ML, so please include main
> info in the thread (driver name / wireless chipset).
> 
> 
> > My kernel version is 3.8.0-19-generic. Which driver should I use for the  WiFi Link 4965AGN? I am a little confused by the numbering.
> 
> You linked to the "iwlegacy" driver wiki page and this page lists
> 4965AGN chipset as supported. That's pretty obvious you need an
> iwlegacy driver, isn't it?

Perhaps confusion came from fact that iwlegacy is a common/library module.
Driver module for the 4965 chip is iwl4965. I've updated the wiki page with
information about individual modules.

Stanislaw
