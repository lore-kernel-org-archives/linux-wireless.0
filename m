Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:47687 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932286Ab3DBOxo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Apr 2013 10:53:44 -0400
Received: by mail-wg0-f54.google.com with SMTP id a12so537755wgh.33
        for <linux-wireless@vger.kernel.org>; Tue, 02 Apr 2013 07:53:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1364903851.35703.YahooMailNeo@web193501.mail.sg3.yahoo.com>
References: <CAJ-VmomdLY-APqZKTcW9GpfokkrPqDGVoTavj=wwjZpj_yL14A@mail.gmail.com>
	<515A0847.7000306@gmail.com>
	<1364903851.35703.YahooMailNeo@web193501.mail.sg3.yahoo.com>
Date: Tue, 2 Apr 2013 07:53:42 -0700
Message-ID: <CAJ-Vmo=4Jbx6n8MO-=XkvNMOxvxHp-dN_hqKaHX9+nbGaqcn5A@mail.gmail.com> (sfid-20130402_165348_039579_EF9D6502)
Subject: Re: AR9287; mapping between GPIOs and COEX pins
From: Adrian Chadd <adrian@freebsd.org>
To: sandeep suresh <sandeep.suresh@yahoo.co.in>
Cc: ath9k-devel <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It depends on what the card manufacturer has done.




Adrian

On 2 April 2013 04:57, sandeep suresh <sandeep.suresh@yahoo.co.in> wrote:
> Hello All,
>         In AR9287, there are ten GPIOs and GPIO[0:3] are mapped to JTAG.
> Remaining GPIOs [4:9] are free. Can you please help me with the mapping of
> GPIO pins to COEX pins? That means which GPIO is connected to:
> a) WLAN_ACTIVE
> b)BT_PRIORITY
> c)BT_ACTIVE
> d)BT_FREQUENCY
>
> Thanks & regards
> Sandeep.
