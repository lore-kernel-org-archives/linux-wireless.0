Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:63856 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932454Ab2DYX2V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Apr 2012 19:28:21 -0400
Received: by qcro28 with SMTP id o28so403250qcr.19
        for <linux-wireless@vger.kernel.org>; Wed, 25 Apr 2012 16:28:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120425193614.GD16900@tuxdriver.com>
References: <1334868960.7300.10.camel@dfry-linux1> <20120420140917.GA13844@tuxdriver.com>
 <193F82CA5D80C84A83D67BB5D5B9FDE548154FE8@ORSMSX101.amr.corp.intel.com> <20120425193614.GD16900@tuxdriver.com>
From: Kay Sievers <kay@vrfy.org>
Date: Thu, 26 Apr 2012 01:28:00 +0200
Message-ID: <CAPXgP12LXNT8S84uJR01od0Ri39N05dkmo+yxbwDwxmj84avAg@mail.gmail.com> (sfid-20120426_012834_086320_E946D8BA)
Subject: Re: question on non-kernel patch
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Fry, Donald H" <donald.h.fry@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"jcm@redhat.com" <jcm@redhat.com>,
	"linux-modules@vger.kernel.org" <linux-modules@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 25, 2012 at 21:36, John W. Linville <linville@tuxdriver.com> wrote:
> Jon, Kay, anyone?
>
> Should Intel just proceed with their kernel patch and not worry about
> the 'modprobe -r' complications, as Michal Marek suggested?

Yes, I would just go ahead and wouldn't worry too much about
additional modules being pulled-in which also need to be unloaded, in
case something really needs to unloaded.

We usually do not support module unloading during normal system
operation. It is mainly a nice and convenient debugging and developing
tool, which people who use it will figure out how to do it.

Kay
