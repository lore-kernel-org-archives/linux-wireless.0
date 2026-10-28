Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793199474;
	b=RhxwZfKqM3MWPSglZ7UZWHxXvS2I9bAbcNbgJ/ANNRHKKWBvYVeIRvUt2kwiLZ/WDegV
	 IF0dCD/0cJFqsPfffSRlGpBIW+EsGORE/Rr7PmCFPU25nchQDVjdMP3nA1tpyotcLn9Ow
	 fUlKAA6i5H5U764v2rjfPYsU7MfOjtQtVfLRI0IFwPKcRc3SEezcOjD64oBlX2Cd2PwzE
	 QQHWt2GNJt/kOLEupe+m3nJnKsh8s287uFtielVo7hqFvyzrUTjlTgHRVvNsS+3/irywS
	 HNhuCXJX4VVZQfeqH8VAqiZgIJs1e1Xi5UBpwM5TXsvRdHIeNdi4f4ApeAierrPju7A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793199474;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=1aJCqrlea8ZrY27B4TMFDN2LGhln7d1dehrunf+FMQs=;
	b=Y+ayh7CpIbxx+OIZbiRayztQNKiHQotUKNLy0eEaBGCyd2jji0ymeBPlC3VSixz37dJD
	 raZyOzy+sFzInN5BGneM7zL3cdNHg8NaeF7t5xm8x99u6tG+ynwS35K0HJkTAoZv0dWVU
	 fSSgRiQqAGWJgu2azbHWNS7cmqLJSm2KnCxm8COK/8mO/qZLshs72Heejz9X6hms5g0jz
	 w4AH1gPPGLy4/5hguClxuPZYIChLiXlc3GQYx8lrgscfH8ZFcK7RaRzyPucaUsRDFVtyC
	 epG/2givWUrVa643SKxeZR2CrFpUCSdJk8bpZVlf4goM/Wl9lNN0XwY0MHwjB7fbkLA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mhG3muBV;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F141606A31C;
	Wed, 28 Oct 2026 14:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mhG3muBV
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793199473;
	b=RqsfGwmyi4RxwJ4VTKg+Sc3xxHOpUiPa40oLUQRIXIhDoVtTlhp2OO10RoKE3rG59OYQ
	 QOZblKjKrNIT2Pom8I1W4Tg8iAYy1Y0N3zQgZPneabU3/Puvm4zGVHRv+i/zUlyDT6n51
	 2Bg6nhEotkzQGsd9GMdqS+79Eva+9Lgi0IRagBgx+cwX7522JCB7ycOsLIL2KGmCWUtMV
	 MFuexBfm45YQnpqRUPQOPP4J6oAHijusWDpw+JVeaU7l4EHO+8O0sWxlqMueX5UTE0Gmr
	 zeVuOzs1c1rIh361oVb1R7OfAb4okVV6b4tOm9r1Lzw4wfQf+pq1eWaFngIyxYPEc+w==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793199473;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=1aJCqrlea8ZrY27B4TMFDN2LGhln7d1dehrunf+FMQs=;
	b=ogmEYXFOS6PF0HSCrKFDIWwsmT4eAs0jWHSK2C7EIxmpxH3YIRBEDb7Gc1t0m4+eaebc
	 Hg5Rwpcc9FbP14C7IDc707EIwPWeR+IHrnKoc7nEObv7t0p0kcLD+ocIgr7hSC6ms9bf0
	 Z8ockSs4YBnXSg6T1O6/zfj+7AHhZPl4N3FPoo03JoITIn9hlKFnu+9obkHo1B3EPocsr
	 kH/JLRNYc1HI6e6R8BL41DexPHgygW2V4R+cO0YZqH24YhbeldD1YfVUhauKDN/StjvhJ
	 +qUPyt3Q+Pjd9s8xquOVM/s7UUIPkbpqweEeKP5gk2i0f8xdwVxhK+mPKlNrZjrw5pg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id A15B61F01825;
	Wed, 28 Oct 2026 14:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793199473;
	bh=1aJCqrlea8ZrY27B4TMFDN2LGhln7d1dehrunf+FMQs=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=mhG3muBV6fAsnLvKukIU3KfcSdtSGNZtKzTAo4ozXycf6NzOZW+ScRVhFpHx8euRB
	 hDdbyzUb8bqEil5jD6xyJlN/2yriELwQOc2oSu0L2li/UbU10KXJTXDG6TDrmq18Wg
	 OFdDc+VS05FerD3lzADrdz7xIcTdc6vn0IkqKk1TIWFkvgcwJBybSLGDtxDumOWCxs
	 gokLACg0yYIhNeDiHorFdKx9EyIYIgEfrA5c/xh+w8jrpI2V17k/Fz+cMl9WHZ1it5
	 I6m2awnSLiTvLGsDmPLxIM4GOtyH676nQWysACP2TJKQI6XY+c+MTZF/dxVUlFEvyC
	 DOdzCNCWLDu1A==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 0604B454C1;
	Wed, 28 Oct 2026 14:57:51 +0000 (UTC)
From: Christopher Griffin via B4 Relay <devnull+christophergriffin05.gmail.com@kernel.org>
Date: Wed, 28 Oct 2026 09:57:51 -0500
Subject: [PATCH wireless-next] wifi: mac80211: flush TX for a new key only
 if it needs tailroom
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261028-b4-mac80211-tailroom-v1-1-f3cfbab9ef5f@gmail.com>
X-B4-Tracking: v=1; b=H4sIAG4N4moC/yWMQQrCMBAAv1L27EIS2hL8inhI0o2utIlkoxZK/
 26qx2GY2UCoMAmcuw0KvVk4pwb61EG4u3Qj5KkxGGVGrYxF3+PiglVGa6yO55Lzgr0dVPR2Iho
 jtPRZKPL6217gw4VmEsFEa4XrX8vLPyjUYw37/gVFEo1OhwAAAA==
X-Change-ID: 20261028-b4-mac80211-tailroom-4850fb8dee6f
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Christopher Griffin <christophergriffin05@gmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793199470; l=6194;
 i=christophergriffin05@gmail.com; s=20261024; h=from:subject:message-id;
 bh=VVRIR+z05sVgNPbb1Hz7v+/VmM8Tn2LY06AEVY6Gvuo=;
 b=riVuGQy3wUiwpyg36tH+bNlgkKY6M1SeroWWKn6mwxv9nf1y7Wx1dMHzWRLWeXRgc4dTLYe8o
 4RKBBP/wyA4AwZASA8w2AbLqbBlEyUcY5j4CCW/9vKJ5ozKwKwda7ww
X-Developer-Key: i=christophergriffin05@gmail.com; a=ed25519;
 pk=oa9tkTNpiGoFWdGvpDHXLSobApmsh9BfrJRJrRJAvWA=
X-Endpoint-Received: by B4 Relay for
 christophergriffin05@gmail.com/20261024 with auth_id=1309
X-Original-From: Christopher Griffin <christophergriffin05@gmail.com>
Reply-To: christophergriffin05@gmail.com
Content-Transfer-Encoding: 7bit

From: Christopher Griffin <christophergriffin05@gmail.com>

ieee80211_key_link() counts every key it installs as needing tailroom
before ieee80211_key_replace() uploads it to the driver, and
increment_tailroom_need_count() runs synchronize_net() when that count
goes from zero to one. On an AP whose keys are all in hardware the count
is zero between stations, so each station's pairwise key waits for an
RCU grace period, and hostapd waits on its NL80211_CMD_NEW_KEY before
it authorizes the station and serves anyone else. Commit 133bf90dbb8b
("mac80211: restrict delayed tailroom needed decrement") keeps the
delayed decrement, which avoids this on a roam, to station interfaces.

Measured on an IPQ8074 AP (ath11k, HZ=100), WPA2-PSK, the same non-MFP
station roaming in, hostapd's NEW_KEY for the pairwise key to its next
step: 31-65 ms (median ~42, 10 joins) on a BSS without PMF; 0-2 ms on
the same BSS with ieee80211w=1, whose software BIP keys (ath11k leaves
BIP to mac80211) keep the count above zero. A driver that does BIP in
hardware pays it with PMF on too.

The flush keeps frames sized without tailroom from meeting a key that
needs it in software. A key that replaces none can't be met before
ieee80211_key_replace() publishes it, by which time it is known whether
it went to the hardware without needing tailroom, giving the count
back. So keep counting it beforehand, but flush on the count's
transition from zero to one only if the key still needs tailroom when
it is about to be published. A key replacing another is handled as
before, since the old key may drop to software while still in use.

With this, the same joins took 0-2 ms without PMF (13 handshakes).

Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Christopher Griffin <christophergriffin05@gmail.com>
---
 net/mac80211/key.c | 61 ++++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 50 insertions(+), 11 deletions(-)

diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index d32c61a90..ee646f5d5 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -73,6 +73,20 @@ update_vlan_tailroom_need_count(struct ieee80211_sub_if_data *sdata, int delta)
 	rcu_read_unlock();
 }
 
+/*
+ * Count a key as needing tailroom, and return whether the count went from
+ * zero to one, so that TX must be flushed before a key needing tailroom is
+ * used (see increment_tailroom_need_count()).
+ */
+static bool __increment_tailroom_need_count(struct ieee80211_sub_if_data *sdata)
+{
+	lockdep_assert_wiphy(sdata->local->hw.wiphy);
+
+	update_vlan_tailroom_need_count(sdata, 1);
+
+	return !sdata->crypto_tx_tailroom_needed_cnt++;
+}
+
 static void increment_tailroom_need_count(struct ieee80211_sub_if_data *sdata)
 {
 	/*
@@ -94,11 +108,7 @@ static void increment_tailroom_need_count(struct ieee80211_sub_if_data *sdata)
 	 * http://mid.gmane.org/1308590980.4322.19.camel@jlt3.sipsolutions.net
 	 */
 
-	lockdep_assert_wiphy(sdata->local->hw.wiphy);
-
-	update_vlan_tailroom_need_count(sdata, 1);
-
-	if (!sdata->crypto_tx_tailroom_needed_cnt++) {
+	if (__increment_tailroom_need_count(sdata)) {
 		/*
 		 * Flush all XMIT packets currently using HW encryption or no
 		 * encryption at all if the count transition is from 0 -> 1.
@@ -569,10 +579,11 @@ int ieee80211_key_slot_lookup(struct ieee80211_sub_if_data *sdata,
 	return err;
 }
 
-static int ieee80211_key_replace(struct ieee80211_sub_if_data *sdata,
-				 struct ieee80211_key_slot *slot,
-				 struct ieee80211_key *old,
-				 struct ieee80211_key *new)
+static int __ieee80211_key_replace(struct ieee80211_sub_if_data *sdata,
+				   struct ieee80211_key_slot *slot,
+				   struct ieee80211_key *old,
+				   struct ieee80211_key *new,
+				   bool flush)
 {
 	bool defunikey, defmultikey, defmgmtkey, defbeaconkey;
 	struct ieee80211_local *local = sdata->local;
@@ -618,6 +629,15 @@ static int ieee80211_key_replace(struct ieee80211_sub_if_data *sdata,
 			if (!ieee80211_key_needs_tailroom(new))
 				decrease_tailroom_need_count(sdata, 1);
 		}
+
+		/*
+		 * The new key isn't visible to TX yet. If counting it took the
+		 * tailroom count from zero to one, flush TX before it is,
+		 * unless it went to the hardware needing no tailroom and so
+		 * gave the count back.
+		 */
+		if (!ret && flush && ieee80211_key_needs_tailroom(new))
+			synchronize_net();
 	}
 
 	if (ret)
@@ -693,6 +713,14 @@ static int ieee80211_key_replace(struct ieee80211_sub_if_data *sdata,
 	return 0;
 }
 
+static int ieee80211_key_replace(struct ieee80211_sub_if_data *sdata,
+				 struct ieee80211_key_slot *slot,
+				 struct ieee80211_key *old,
+				 struct ieee80211_key *new)
+{
+	return __ieee80211_key_replace(sdata, slot, old, new, false);
+}
+
 struct ieee80211_key *
 ieee80211_key_alloc(u32 cipher, int idx, size_t key_len,
 		    const u8 *key_data,
@@ -964,6 +992,7 @@ int ieee80211_key_link(struct ieee80211_sub_if_data *sdata,
 	static atomic_t key_color = ATOMIC_INIT(0);
 	struct ieee80211_key *old_key = NULL;
 	int idx = key->conf.keyidx;
+	bool flush = false;
 	int ret;
 
 	lockdep_assert_wiphy(sdata->local->hw.wiphy);
@@ -1031,9 +1060,19 @@ int ieee80211_key_link(struct ieee80211_sub_if_data *sdata,
 		goto out;
 	}
 
-	increment_tailroom_need_count(sdata);
+	/*
+	 * A key replacing another is counted, and TX flushed if that takes
+	 * the count from zero to one, here: the old key may drop to software
+	 * while still in use. A new key isn't used before it is published,
+	 * once it is known whether it went to the hardware without needing
+	 * tailroom, so __ieee80211_key_replace() flushes TX only if not.
+	 */
+	if (old_key)
+		increment_tailroom_need_count(sdata);
+	else
+		flush = __increment_tailroom_need_count(sdata);
 
-	ret = ieee80211_key_replace(sdata, slot, old_key, key);
+	ret = __ieee80211_key_replace(sdata, slot, old_key, key, flush);
 	if (ret) {
 		decrease_tailroom_need_count(sdata, 1);
 		key->local = NULL;

---
base-commit: 2c50cd5d10e8723797f28c7978f1f61688e0c0d2
change-id: 20261028-b4-mac80211-tailroom-4850fb8dee6f

Best regards,
--  
Christopher Griffin <christophergriffin05@gmail.com>


