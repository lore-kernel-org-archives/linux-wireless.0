Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.189]:35604 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233AbYA0RZQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Jan 2008 12:25:16 -0500
Received: by rv-out-0910.google.com with SMTP id k20so1428003rvb.1
        for <linux-wireless@vger.kernel.org>; Sun, 27 Jan 2008 09:25:16 -0800 (PST)
Message-ID: <c85cb4470801270925x593a9534y5b4c0dbae371098@mail.gmail.com> (sfid-20080127_172520_016307_F1103B52)
Date: Sun, 27 Jan 2008 19:25:15 +0200
From: "Ron Rindjunsky" <rindjon@googlemail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 02/12] mac80211: A-MPDU Tx add MLME structures
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <1201166966.3454.59.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <12009163321727-git-send-email-ron.rindjunsky@intel.com>
	 <12009163392459-git-send-email-ron.rindjunsky@intel.com>
	 <1201166966.3454.59.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > +#define HT_ADDBA_REQUESTED_MSK               BIT(0)
> > +#define HT_ADDBA_DRV_READY_MSK               BIT(1)
> > +#define HT_ADDBA_RECEIVED_MSK                BIT(2)
> >  #define HT_AGG_STATE_REQ_STOP_BA_MSK BIT(3)
> > -
> > +#define HT_AGG_STATE_INITIATOR_MSK      BIT(HT_AGG_STATE_INITIATOR_SHIFT)
> >  #define HT_AGG_STATE_IDLE            (0x0)
> >  #define HT_AGG_STATE_OPERATIONAL     (0x7)
>
> I think you should probably change the last there to use the first
> three.

will be done

>
> johannes
>
>
