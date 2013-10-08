Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out06.msg.oleane.net ([62.161.7.4]:52908 "EHLO
	smtp-out06.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050Ab3JHLcF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Oct 2013 07:32:05 -0400
Received: from smtp06.msg.oleane.net (smtp06.mail.priv [172.17.20.115])
	by smtp-out06.msg.oleane.net with ESMTP id r9889qux008000
	for <linux-wireless@vger.kernel.org>; Tue, 8 Oct 2013 10:09:53 +0200
From: "Jean-Pierre Tosoni" <jp.tosoni@acksys.fr>
To: <devel@lists.open80211s.org>, <linux-wireless@vger.kernel.org>,
	<yeohchunyeow@cozybit.com>
References: <1380760429-26100-1-git-send-email-yeohchunyeow@cozybit.com>
In-Reply-To: <1380760429-26100-1-git-send-email-yeohchunyeow@cozybit.com>
Subject: RE: [PATCH v3 0/6] Add Mesh Channel Switch Support
Date: Tue, 8 Oct 2013 09:49:14 +0200
Message-ID: <003101cec3fa$e2c1e000$a845a000$@acksys.fr> (sfid-20131008_133210_195663_E64D4187)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, see some typos below.
Jean-Pierre

> -----Message d'origine-----
> De : devel-bounces@lists.open80211s.org [mailto:devel-
> bounces@lists.open80211s.org] De la part de Chun-Yeow Yeoh
> Envoyé : jeudi 3 octobre 2013 02:34
> 
> Limitations:
>  * Channel switch is only allow for the same band and also same channel
>    width from the previous setting.

Allow -> allowed
settings

> 
> These patches are reviewed and commented by Bob Copeland, Thomas
> Pedersen
> and Johannes Berg. Any further comments are welcomed.
> 
> Add seperate patch for refactoring the ieee80211_parse_ch_switch_ie to

Seperate -> separate

> reduce the number of function paramaters.

Parameters

> 
> Chun-Yeow Yeoh (6):
>   mac80211: process the CSA frame for mesh accordingly
>   {nl,cfg,mac}80211: enable the triggering of CSA frame in mesh
>   mac80211: add the CSA and MCSP elements in mesh beaconing
>   mac80211: refactor the parsing of chan switch ie
>   {nl,cfg,mac}80211: finalizing mesh channel switching
>   mac80211: process mesh channel switching using beacon
> 
>  include/linux/ieee80211.h  |   20 +++
>  net/mac80211/Kconfig       |   11 ++
>  net/mac80211/cfg.c         |   24 ++++
>  net/mac80211/debug.h       |   10 ++
>  net/mac80211/ibss.c        |   67 ++--------
>  net/mac80211/ieee80211_i.h |   29 ++++-
>  net/mac80211/mesh.c        |  293
> +++++++++++++++++++++++++++++++++++++++++++-
>  net/mac80211/mlme.c        |   32 +++--
>  net/mac80211/rx.c          |    5 +-
>  net/mac80211/spectmgmt.c   |   33 +++--
>  net/mac80211/tx.c          |   16 +++
>  net/mac80211/util.c        |   96 +++++++++++++++
>  net/wireless/nl80211.c     |    4 +-
>  13 files changed, 540 insertions(+), 100 deletions(-)
> 
> --
> 1.7.9.5
> 
> _______________________________________________
> Devel mailing list
> Devel@lists.open80211s.org
> http://lists.open80211s.org/cgi-bin/mailman/listinfo/devel

