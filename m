Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:42291 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545Ab3JRMtP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Oct 2013 08:49:15 -0400
Received: by mail-ob0-f169.google.com with SMTP id wp4so3062661obc.14
        for <linux-wireless@vger.kernel.org>; Fri, 18 Oct 2013 05:49:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <6F561AC697923E43A7559754DA2EE97C3201BFF0@ADM-EXMBX10D.adm.c.sdu.dk>
References: <6F561AC697923E43A7559754DA2EE97C3201BFF0@ADM-EXMBX10D.adm.c.sdu.dk>
Date: Fri, 18 Oct 2013 14:49:15 +0200
Message-ID: <CACna6rzC_jOeE1=r85EJg=jdrr-gbmKCJ1fFwUwySczRsZskSQ@mail.gmail.com> (sfid-20131018_144919_174816_07C7AE10)
Subject: Re: regarding Linux Wifi driver
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Daniel Wrede <dawre12@student.sdu.dk>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"sgruszka@redhat.com" <sgruszka@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/10/18 Daniel Wrede <dawre12@student.sdu.dk>:
> I do have a question regarding the drivers on http://wireless.kernel.org/en/users/Drivers/iwlegacy

You're writing to generic Linux wireless ML, so please include main
info in the thread (driver name / wireless chipset).


> My kernel version is 3.8.0-19-generic. Which driver should I use for the  WiFi Link 4965AGN? I am a little confused by the numbering.

You linked to the "iwlegacy" driver wiki page and this page lists
4965AGN chipset as supported. That's pretty obvious you need an
iwlegacy driver, isn't it?

-- 
Rafał
