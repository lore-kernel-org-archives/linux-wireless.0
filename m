Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52886 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755726Ab2EBTEy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 May 2012 15:04:54 -0400
Received: by yhmm54 with SMTP id m54so1040414yhm.19
        for <linux-wireless@vger.kernel.org>; Wed, 02 May 2012 12:04:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120502181229.GD9285@tuxdriver.com>
References: <1335472901-12323-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
 <CAG6hwVPx5OSJXAz8Kj-=zDbP8MWUaUKJL1VFtyjZVaQ5Jk_6_g@mail.gmail.com> <20120502181229.GD9285@tuxdriver.com>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Wed, 2 May 2012 12:04:33 -0700
Message-ID: <CAG6hwVNAqPTRKS7xyx9cDej9Y9ufAY+GM2soeRCreDBsfB2NWg@mail.gmail.com> (sfid-20120502_210515_312025_181842EC)
Subject: Re: [PATCH] mac80211: mesh: Remove un-needed defines
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Andrei Emeltchenko <Andrei.Emeltchenko.news@gmail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 2, 2012 at 11:12 AM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Thu, Apr 26, 2012 at 02:41:32PM -0700, Thomas Pedersen wrote:
>> Hi Andrei,
>>
>> On Thu, Apr 26, 2012 at 1:41 PM, Andrei Emeltchenko
>> <Andrei.Emeltchenko.news@gmail.com> wrote:
>> > From: Andrei Emeltchenko <andrei.emeltchenko@intel.com>
>> >
>> > ieee80211_vif_is_mesh is already defined as:
>> >
>> > <------8<--------------------------------------------------------------
>> > |  static inline bool ieee80211_vif_is_mesh(struct ieee80211_vif *vif)
>> > |  {
>> > |  #ifdef CONFIG_MAC80211_MESH
>> > |          return vif->type == NL80211_IFTYPE_MESH_POINT;
>> > |  #endif
>> > |          return false;
>> > |  }
>> > |
>> > <------8<--------------------------------------------------------------
>> >
>> > Signed-off-by: Andrei Emeltchenko <andrei.emeltchenko@intel.com
>>
>> ACK if you tested w/o CONFIG_MAC80211_MESH.
>
> Well...did you??

He dropped the list in his final response. No, it doesn't work.

Thomas
