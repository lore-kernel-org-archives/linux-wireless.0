Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:43326 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728143AbeHVPFS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Aug 2018 11:05:18 -0400
Message-ID: <a7b02075b60c20377f5892f1c2d2a04c98e62f80.camel@coelho.fi> (sfid-20180822_134047_689402_DB2A2F3E)
From: Luca Coelho <luca@coelho.fi>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>
Date: Wed, 22 Aug 2018 14:40:41 +0300
In-Reply-To: <87bm9ur5sg.fsf@kamboji.qca.qualcomm.com>
References: <20180821050952.31603-1-luca@coelho.fi>
         <20180821050952.31603-6-luca@coelho.fi>
         <87bm9ur5sg.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH v2 05/17] iwlwifi: add d3 debug data support
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-08-22 at 14:37 +0300, Kalle Valo wrote:
> Luca Coelho <luca@coelho.fi> writes:
> 
> > From: Shahar S Matityahu <shahar.s.matityahu@intel.com>
> > 
> > During d3, the firmware records debug data into internal buffer
> > if debug data collection occurs, collect the data that was written
> > to the
> > buffer
> > 
> > Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
> > Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> 
> [...]
> 
> > --- a/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h
> > +++ b/drivers/net/wireless/intel/iwlwifi/fw/error-dump.h
> > @@ -8,6 +8,7 @@
> >   * Copyright(c) 2014 Intel Corporation. All rights reserved.
> >   * Copyright(c) 2014 - 2015 Intel Mobile Communications GmbH
> >   * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
> > + * Copyright (C) 2018 Intel Corporation
> >   *
> >   * This program is free software; you can redistribute it and/or
> > modify
> >   * it under the terms of version 2 of the GNU General Public
> > License as
> > @@ -18,11 +19,6 @@
> >   * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > GNU
> >   * General Public License for more details.
> >   *
> > - * You should have received a copy of the GNU General Public
> > License
> > - * along with this program; if not, write to the Free Software
> > - * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
> > 02110,
> > - * USA
> > - *
> >   * The full GNU General Public License is included in this
> > distribution
> >   * in the file called COPYING.
> >   *
> 
> Is this removal intentional? Just curious.

Yeah, it's intentional.  Checkpatch complains about that, so we're
removing whenever we hit the warning (i.e. when we have a change,
usually in the copyright lines, that include this paragraph in the
context).

--
Luca.
