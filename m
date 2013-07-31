Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:49730 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316Ab3GaGrm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Jul 2013 02:47:42 -0400
Message-ID: <1375253258.8289.5.camel@jlt4.sipsolutions.net> (sfid-20130731_084744_690301_F13FF4FB)
Subject: Re: [PATCH 15/30] iwlwifi: mvm: reprobe device on firmware error
 during restart
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 31 Jul 2013 08:47:38 +0200
In-Reply-To: <CAB3XZEcZX8u5Fcsf7mbbso9O0krhLVgzdT9Ay8dxsv_T+_SOhQ@mail.gmail.com> (sfid-20130730_235612_198515_881B7B34)
References: <1374827327-3464-1-git-send-email-johannes@sipsolutions.net>
	 <1374827327-3464-16-git-send-email-johannes@sipsolutions.net>
	 <CAB3XZEcZX8u5Fcsf7mbbso9O0krhLVgzdT9Ay8dxsv_T+_SOhQ@mail.gmail.com>
	 (sfid-20130730_235612_198515_881B7B34)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-07-31 at 00:56 +0300, Eliad Peller wrote:

> > +               reprobe = kzalloc(sizeof(*reprobe), GFP_ATOMIC);
> > +               if (!reprobe)
> > +                       return;
> 
> missing module_put() :)

Doh, good catch. All the more reason to respin this pull request.

johannes

