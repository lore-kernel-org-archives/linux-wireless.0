Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:43696 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727682AbeIFOWh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Sep 2018 10:22:37 -0400
Message-ID: <1536227267.4015.2.camel@sipsolutions.net> (sfid-20180906_114841_098027_66B50F07)
Subject: Re: [PATCH] mac80211: fix TX status reporting for ieee80211s
From: Johannes Berg <johannes@sipsolutions.net>
To: Yuan-Chi Pang <fu3mo6goo@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 06 Sep 2018 11:47:47 +0200
In-Reply-To: <1536227104.68915.5.camel@gmail.com> (sfid-20180906_114516_051319_173379BB)
References: <1535963610.3437.10.camel@sipsolutions.net>
         <1536224269-69350-1-git-send-email-fu3mo6goo@gmail.com>
         <1536227104.68915.5.camel@gmail.com> (sfid-20180906_114516_051319_173379BB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2018-09-06 at 17:45 +0800, Yuan-Chi Pang wrote:
> 
> I received the comment of my previous submission that I should fix
> indentation. But if I use the same indentation as before, I got "line
> over 80 characters" warning by checkpatch. What should I do?
> 
> > diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
> > index daf9db3..4286673 100644
> > --- a/net/mac80211/mesh_hwmp.c
> > +++ b/net/mac80211/mesh_hwmp.c
> > @@ -295,15 +295,11 @@ int mesh_path_error_tx(struct
> > ieee80211_sub_if_data *sdata,
> >  }
> >  
> >  void ieee80211s_update_metric(struct ieee80211_local *local,
> > -		struct sta_info *sta, struct sk_buff *skb)
> > +		struct sta_info *sta, struct ieee80211_tx_status
> > *st)

Here? Seems easy - add a linebreak between sta and status?

johannes
