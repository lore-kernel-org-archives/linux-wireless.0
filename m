Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:62750 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772Ab1GSPc6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2011 11:32:58 -0400
Received: by fxd18 with SMTP id 18so199037fxd.11
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jul 2011 08:32:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <477F20668A386D41ADCC57781B1F704307FFB0947D@SC-VEXCH1.marvell.com>
References: <20110717170310.CAD139D401C@zog.reactivated.net>
	<477F20668A386D41ADCC57781B1F704307FFB0947D@SC-VEXCH1.marvell.com>
Date: Tue, 19 Jul 2011 16:32:57 +0100
Message-ID: <CAGq3pz6DbsHG9JY8oZqaeRp4=EC1-sKunSuF2Q1+tfBoYbcyLg@mail.gmail.com> (sfid-20110719_173301_488967_915A55A6)
Subject: Re: [PATCH 1/4] libertas: remove auto_deep_sleep functionality
From: Daniel Drake <dsd@laptop.org>
To: Bing Zhao <bzhao@marvell.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"dcbw@redhat.com" <dcbw@redhat.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"libertas-dev@lists.infradead.org" <libertas-dev@lists.infradead.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Frank Huang <frankh@marvell.com>
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 18 July 2011 20:25, Bing Zhao <bzhao@marvell.com> wrote:
> As the auto deep sleep feature for SD8385/SD8686/SD8688 cards is very useful for many embedded platforms to handle enter/exit deep sleep mode automatically, please do not remove it from libertas driver. If you have any particular issue with this feature enabled, we can work on it and solve the problem.

The problem is that it can't actually be enabled. This is dead code.
Or if it can, please point out what I'm missing.

Or is this a work in progress?

Thanks,
Daniel
